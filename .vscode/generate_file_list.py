import argparse
import logging
import math
import os
import random
import subprocess
import urllib.parse
from collections import defaultdict

# --- Configuration ---

# Fallback repository URL
# Specifies the fallback URL of the GitHub repository if the default URL cannot be determined by get_git_repo_url.
FALLBACK_REPO_URL = "https://github.com/author/repo"


def get_git_repo_url():
    try:
        result = subprocess.run(
            ["git", "config", "--get", "remote.origin.url"],
            capture_output=True,
            text=True,
            check=True,
        )
        url = result.stdout.strip()

        # Check if the URL ends with ".git" and remove it
        if url.endswith(".git"):
            url = url[:-4]

        # Ensure the URL is an HTTPS URL by converting SSH URLs if necessary
        if url.startswith("git@"):
            url = url.replace(":", "/").replace("git@", "https://")

        return url
    except subprocess.CalledProcessError as e:
        logging.error(
            f"\033[1;31mError getting Git repository URL: {e}\033[0m", exc_info=True
        )

        return FALLBACK_REPO_URL


# --- Configuration ---
# Default GitHub repository URL
# Specifies the default URL of the GitHub repository.
DEFAULT_GIT_REPO_URL = get_git_repo_url()

# Root directory
# Specifies the root directory of the repository to generate the file list for.
# Default value is the current directory.
ROOT_DIRECTORY = "."

# Output file name
# Specifies the default name of the output HTML file.
DEFAULT_OUTPUT_FILE = "file_list.html"

# Color source
# Specifies the source of the colors used for the links.
# Options:
# - "random": Colors are generated randomly.
# - "list": Colors are chosen from a predefined list.
DEFAULT_COLOR_SOURCE = "random"

# Predefined color list
# Specifies a list of predefined colors to choose from when the color source is set to "list".
DEFAULT_COLOR_LIST = ["#FF0000", "#00FF00",
                      "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF"]

# Color range
# Specifies the range of colors for random color generation.
# This should be a tuple of two hexadecimal color codes representing the lower and upper bounds of the range.
# Default value is None, which indicates the full random range.
# Example: DEFAULT_COLOR_RANGE = ("#000000", "#FFFFFF")
DEFAULT_COLOR_RANGE = None

# Ignore list
# Specifies a list of files and folders to ignore during the directory walk.
IGNORE_LIST = [".git", "node_modules", ".DS_Store",
               ".history", "styles", "zwiftbikes"]

# Chunk size
# Specifies the number of lines per chunk for lazy loading.
CHUNK_SIZE = 40

# File categories
# Specifies categories of files based on their extensions.
# Each category includes:
# - ext: The file extension.
# - name: The display name of the category.
# - files: An empty list that will be populated with files matching the extension.
FILE_CATEGORIES = [
    {"ext": ".user.css", "name": "Userstyles", "files": []},
    {"ext": ".user.js", "name": "Userscripts", "files": []},
    {"ext": ".css", "name": "CSS", "files": []},
    {"ext": ".js", "name": "JavaScript", "files": []},
    {"ext": ".yml", "name": "YAML", "files": []},
]

# REPO_ROOT_HEADER determines the header text for files that are in the root of the repository.
# This is useful for files that are not in a folder.
REPO_ROOT_HEADER = "Repo Root"

# HEADER_TEXT determines the header text for the file list.
# This is displayed at the top of the generated HTML file.
HEADER_TEXT = "## File List"

# INTRO_TEXT determines the introductory text for the file list.
# This is displayed below the header in the generated HTML file.
INTRO_TEXT = "# Here is a list of files included in this repository:"


# Color exclusion options

# If set to True, excludes dark colors from being used.
EXCLUDE_DARK_COLORS = False
# Luminance threshold for determining if a color is dark (anything below this will be considered dark)
DARK_COLOR_LUMINANCE_THRESHOLD = 128

# If set to True, excludes bright colors from being used.
EXCLUDE_BRIGHT_COLORS = False
# Luminance threshold for determining if a color is bright (anything above this will be considered bright)
BRIGHT_COLOR_LUMINANCE_THRESHOLD = 200

# If set to True, excludes colors below the EXCLUDE_BLACKS_THRESHHOLD color from being used.
EXCLUDE_BLACKS = True
# Any colors below this will not be generated if EXCLUDE_BLACKS is set to True.
# (Below Refers To Vertically on the Color Picker)
# Example: EXCLUDE_BLACKS_THRESHOLD = "#222222"
EXCLUDE_BLACKS_THRESHOLD = "#222222"
# Max attempts to try to find a color below the threshhold. Useful if you set the EXCLUDE_BLACK_THRESHOLD really high.
MAX_ATTEMPTS = 100
# If set to True, ensures that the generated colors are readable by maintaining a certain contrast ratio with a white background.
ENSURE_READABLE_COLORS = True
# Log Level Setting for the logger, defaults to INFO.
# Choices: "DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"
LOG_LEVEL_SETTING = "INFO"
# --- End Configuration ---

LOG_LEVEL = os.getenv("LOG_LEVEL", LOG_LEVEL_SETTING).upper()

logging.basicConfig(
    level=getattr(logging, LOG_LEVEL),
    format="%(asctime)s - %(levelname)s - %(message)s",
)


def should_ignore(path, ignore_list):
    try:
        path_parts = set(path.split(os.sep))
        return any(ignore_item in path_parts for ignore_item in ignore_list)
    except Exception as e:
        logging.error(f"\033[1;31mError in should_ignore function: {e}\033[0m")
        return False


def generate_file_list(directory, ignore_list):
    file_list = set()
    try:
        for root, dirs, files in os.walk(directory):
            # Filter directories in-place to avoid walking into ignored directories
            dirs[:] = list(
                filter(
                    lambda d: not should_ignore(
                        os.path.join(root, d), ignore_list),
                    dirs,
                )
            )
            for file in files:
                file_path = os.path.join(root, file)
                ignore_file = should_ignore(file_path, ignore_list)
                if not ignore_file:
                    file_list.add(os.path.relpath(file_path, directory))
        logging.info(
            f"\033[1;32mGenerated file list with {len(file_list)} files.\033[0m"
        )
    except (OSError, ValueError) as e:
        logging.error(
            f"\033[1;31mError generating file list: {type(e).__name__}: {e}\033[0m"
        )
    return list(file_list)


def calculate_luminance(hex_color):
    try:
        r, g, b = [int(hex_color[i: i + 2], 16) for i in (1, 3, 5)]
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    except ValueError as e:
        logging.error(
            f"\033[1;31mError calculating luminance for color {hex_color}: {e}\033[0m"
        )
        return 0


def is_dark_color(hex_color):
    try:
        luminance = calculate_luminance(hex_color)
        return luminance < DARK_COLOR_LUMINANCE_THRESHOLD
    except Exception as e:
        logging.error(f"\033[1;31mError in is_dark_color function: {e}\033[0m")
        return False


def is_bright_color(hex_color):
    try:
        luminance = calculate_luminance(hex_color)
        return luminance > BRIGHT_COLOR_LUMINANCE_THRESHOLD
    except Exception as e:
        logging.error(
            f"\033[1;31mError in is_bright_color function: {e}\033[0m")
        return False


def is_readable_color(hex_color):
    try:
        luminance = calculate_luminance(hex_color)
        return 50 < luminance < 200
    except Exception as e:
        logging.error(
            f"\033[1;31mError in is_readable_color function: {e}\033[0m")
        return False


def get_random_color(color_range=None):
    """
    Generates a random color (in hex) within the specified range if provided,
    avoiding excluded colors.
    """

    if color_range and any(
        int(color_range[0][i: i + 2], 16) > int(color_range[1][i: i + 2], 16)
        for i in range(1, 7, 2)
    ):
        logging.error(
            f"\033[1;31mInvalid color range: {color_range[0]} should be <= {color_range[1]}\033[0m"
        )
        return "#000000"
    for _ in range(MAX_ATTEMPTS):
        if color_range:
            r_min, g_min, b_min = [
                int(color_range[0][i: i + 2], 16) for i in (1, 3, 5)
            ]
            r_max, g_max, b_max = [
                int(color_range[1][i: i + 2], 16) for i in (1, 3, 5)
            ]
            r = random.randint(r_min, r_max)
            g = random.randint(g_min, g_max)
            b = random.randint(b_min, b_max)
            color = f"#{r:02x}{g:02x}{b:02x}"
        else:
            color = f"#{random.randint(0, 0xFFFFFF):06x}"
        if not should_exclude_color(color):
            return color
    logging.error(
        "\033[1;31mFailed to generate a valid color within max attempts.\033[0m"
    )
    return "#000000"


def should_exclude_color(color):
    if EXCLUDE_DARK_COLORS and is_dark_color(color):
        return True
    if EXCLUDE_BRIGHT_COLORS and is_bright_color(color):
        return True
    if EXCLUDE_BLACKS and is_black_color(color):
        return True
    if ENSURE_READABLE_COLORS and not is_readable_color(color):
        return True
    return False


def is_black_color(color):
    color_int_value = int(color[1:], 16)
    threshold_value = int(EXCLUDE_BLACKS_THRESHOLD[1:], 16)
    return color_int_value <= threshold_value


def generate_file_list_with_links(
    file_list, repo_url, color_source="random", color_range=None, color_list=None
):
    color_list = color_list or DEFAULT_COLOR_LIST
    file_list_html = defaultdict(list)
    try:
        for file in file_list:
            file_url = f"{repo_url}/blob/main/{file.replace(os.sep, '/')}"
            file_url = urllib.parse.quote(file_url, safe="/:")

            if color_source == "random":
                color = get_random_color(color_range)
            elif color_source == "list":
                color = random.choice(color_list)
            else:
                color = "#000000"

            for category in FILE_CATEGORIES:
                if file.endswith(category["ext"]):
                    category["files"].append(
                        f'<li><a href="{file_url}" style="color: {color};">{file.replace(os.sep, "/")}</a></li>'
                    )
                    break
            else:
                folder = os.path.dirname(file)
                file_list_html[folder].append(
                    f'<li><a href="{file_url}" style="color: {color};">{file.replace(os.sep, "/")}</a></li>'
                )

        logging.info(
            f"\033[1;32mGenerated HTML links for {len(file_list)} files.\033[0m"
        )
    except (OSError, ValueError, KeyError) as e:
        logging.error(
            f"\033[1;31mError generating HTML links: {type(e).__name__}: {e}\033[0m"
        )

    sorted_html = []

    root_files = []
    if "" in file_list_html:
        root_files = file_list_html.pop("")

    if root_files:
        sorted_html.append(f"<li><h2>{REPO_ROOT_HEADER}</h2></li>")
        sorted_html.extend(
            sorted(root_files, key=lambda x: os.path.splitext(x)[1]))

    for category in FILE_CATEGORIES:
        if category["files"]:
            sorted_html.append(f'<li><h2>{category["name"]}</h2></li>')
            sorted_html.extend(sorted(category["files"]))

    for folder in sorted(file_list_html):
        sorted_html.append(f"<li><h2>{folder}</h2></li>")
        sorted_html.extend(sort_files_by_extension(file_list_html[folder]))

    sorted_html.append("</ul>")
    return "\n".join(sorted_html)


def sort_files_by_extension(files):
    return sorted(files, key=lambda x: os.path.splitext(x)[1])


def save_file_list(file_list_html, output_file):
    file_list_html = "\n".join(
        line.replace("\\", "/") for line in file_list_html.splitlines()
    )
    file_list_chunks = split_into_chunks(file_list_html, CHUNK_SIZE)

    try:
        with open(output_file, "w", encoding="utf-8") as f:
            write_html_header(f)
            # Write placeholders for lazy loading the file list chunks
            write_lazyload_placeholders(f, file_list_chunks)
            write_lazyload_script(f, file_list_chunks)
        logging.info(f"\033[1;32mFile list saved to {output_file}\033[0m")
    except (IOError, OSError) as e:
        logging.error(
            f"\033[1;31mError saving file list to {output_file}: {e}\033[0m",
            exc_info=True,
        )


def split_into_chunks(file_list_html, chunk_size):
    """
    Splits the given HTML file list into chunks of a specified size.

    Args:
        file_list_html (str): The HTML content of the file list.
        chunk_size (int): The number of lines per chunk.

    Returns:
        list: A list of HTML chunks, each containing up to chunk_size lines.
    """
    file_list_chunks = []
    current_chunk = []
    for line in file_list_html.splitlines():
        current_chunk.append(line)
        if len(current_chunk) >= chunk_size:
            file_list_chunks.append("\n".join(current_chunk))
            current_chunk = []
    if current_chunk:
        file_list_chunks.append("\n".join(current_chunk))
    return file_list_chunks


def write_html_header(f):
    f.write(f"<h1>{HEADER_TEXT}</h1>\n\n")
    f.write(f"<p>{INTRO_TEXT}</p>\n\n")


def write_lazyload_placeholders(f, file_list_chunks):
    for i in range(len(file_list_chunks)):
        f.write(
            f"""<div class="lazyload-placeholder" data-content="file-list-{i+1}" style="min-height: 400px;"></div>\n"""
        )


def write_lazyload_script(f, file_list_chunks):
    f.write(
        "<script>\n"
        'document.addEventListener("DOMContentLoaded", function() {\n'
        "    const lazyLoadElements = document.querySelectorAll('.lazyload-placeholder');\n"
        "\n"
        '    if ("IntersectionObserver" in window) {\n'
        "        let rootMargin = '0px 0px 400px 0px';\n"
        "        let threshold = 0.5;\n"
        "        if (window.innerWidth <= 768) {  // Mobile devices\n"
        "            rootMargin = '0px 0px 100px 0px';\n"
        "            threshold = 0.1;\n"
        "        } else if (window.innerWidth <= 1024) {  // Tablets\n"
        "            rootMargin = '0px 0px 200px 0px';\n"
        "            threshold = 0.3;\n"
        "        } else if (window.innerWidth <= 1440) {  // Small desktops\n"
        "            rootMargin = '0px 0px 300px 0px';\n"
        "            threshold = 0.4;\n"
        "        } else {  // Large desktops\n"
        "            rootMargin = '0px 0px 400px 0px';\n"
        "            threshold = 0.5;\n"
        "        }\n"
        "        let observer = new IntersectionObserver((entries, observer) => {\n"
        "            entries.forEach(entry => {\n"
        "                if (entry.isIntersecting) {\n"
        "                    let placeholder = entry.target;\n"
        "                    let contentId = placeholder.dataset.content;\n"
        "                    let file_list_html = '';\n"
        "                    switch(contentId) {\n"
    )
    for i in range(len(file_list_chunks)):
        f.write(
            f"                        case 'file-list-{i+1}':\n"
            f"                            file_list_html = `<ul>{file_list_chunks[i]}</ul>`;\n"
            f"                            break;\n"
        )
    f.write(
        "                    }\n"
        "                    placeholder.innerHTML = file_list_html;\n"
        "                    observer.unobserve(placeholder);\n"
        "                    console.log(`Loaded content for ${contentId}`);\n"
        "                }\n"
        "            });\n"
        "        }, { rootMargin: rootMargin, threshold: threshold });\n"
        "\n"
        "        lazyLoadElements.forEach(element => {\n"
        "            element.style.marginTop = '-17px';\n"
        "            observer.observe(element);\n"
        "        });\n"
        "    } else {\n"
        "        lazyLoadElements.forEach(placeholder => {\n"
        "            let contentId = placeholder.dataset.content;\n"
        "            let file_list_html = '';\n"
        "            switch(contentId) {\n"
    )
    for i in range(len(file_list_chunks)):
        f.write(
            f"                case 'file-list-{i+1}':\n"
            f"                    file_list_html = `<ul>{file_list_chunks[i]}</ul>`;\n"
            f"                    break;\n"
        )
    f.write(
        "            }\n"
        "            placeholder.innerHTML = file_list_html;\n"
        "        });\n"
        "    }\n"
        "});\n"
        "</script>\n"
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Generate a file list for a GitHub repository with HTML links."
    )
    parser.add_argument(
        "--log_level",
        default=LOG_LEVEL_SETTING,
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        help="\033[1;32mSet the logging level setting manually instead of pulling from environment\033[0m",
    )
    parser.add_argument(
        "--directory",
        default=ROOT_DIRECTORY,
        metavar="DIRECTORY",
        help="\033[1;34mRoot directory of the repository to generate the file list for. Default is the current directory.\033[0m",
    )
    parser.add_argument(
        "--repo_url",
        default=DEFAULT_GIT_REPO_URL,
        metavar="REPO_URL",
        help="\033[1;36mGitHub repository URL to use for generating file links. Default is determined by the Git configuration.\033[0m",
    )
    parser.add_argument(
        "--fallback_repo_url",
        default=FALLBACK_REPO_URL,
        metavar="FALLBACK_REPO_URL",
        help="\033[1;35mFallback GitHub repository URL to use if the default URL cannot be determined.\033[0m",
    )
    parser.add_argument(
        "--output_file",
        default=DEFAULT_OUTPUT_FILE,
        metavar="OUTPUT_FILE.html",
        help="\033[1;33mName of the output HTML file to save the generated file list. Default is 'file_list.html'.\033[0m",
    )
    parser.add_argument(
        "--color_source",
        choices=["random", "list"],
        default=DEFAULT_COLOR_SOURCE,
        help="\033[1;32mSource of colors for the file links. Choose 'random' for randomly generated colors or 'list' to use a predefined list of colors.\033[0m",
    )
    parser.add_argument(
        "--color_list",
        nargs="+",
        metavar="COLOR",
        default=DEFAULT_COLOR_LIST,
        help="\033[1;31mList of colors to use when the color source is set to 'list'. Provide colors in hex format (e.g., #FF0000).\033[0m",
    )
    parser.add_argument(
        "--color_range",
        nargs=2,
        metavar=("COLOR_MIN", "COLOR_MAX"),
        default=DEFAULT_COLOR_RANGE,
        help="\033[1;35mRange of colors (hex codes) for random color generation. Provide two hex codes representing the lower and upper bounds (e.g., --color_range #000000 #FFFFFF).\033[0m",
    )
    parser.add_argument(
        "--exclude_dark_colors",
        action="store_true",
        default=EXCLUDE_DARK_COLORS,
        help="\033[1;36mExclude dark colors from being used for file links. Use this option to avoid dark colors.\033[0m",
    )
    parser.add_argument(
        "--exclude_bright_colors",
        action="store_true",
        default=EXCLUDE_BRIGHT_COLORS,
        help="\033[1;33mExclude bright colors from being used for file links. Use this option to avoid bright colors.\033[0m",
    )
    parser.add_argument(
        "--exclude_blacks",
        action="store_true",
        default=EXCLUDE_BLACKS,
        help="\033[1;32mExclude black colors below a certain threshold from being used for file links. Use this option to avoid very dark colors.\033[0m",
    )
    parser.add_argument(
        "--max_attempts",
        type=int,
        metavar=(100),
        default=MAX_ATTEMPTS,
        help="\033[1;34mMaximum number of attempts to generate a valid color. Default is 100.\033[0m",
    )
    parser.add_argument(
        "--exclude_blacks_threshold",
        type=str,
        metavar=("#222222"),
        default=EXCLUDE_BLACKS_THRESHOLD,
        help="\033[1;31mThreshold for excluding black colors. Any color below this threshold on the color chart will be excluded (e.g., #222222).\033[0m",
    )
    parser.add_argument(
        "--ensure_readable_colors",
        action="store_true",
        default=ENSURE_READABLE_COLORS,
        help="\033[1;34mEnsure that the generated colors are readable by maintaining a certain contrast ratio with a white background.\033[0m",
    )
    parser.add_argument(
        "--repo_root_header",
        type=str,
        metavar=("Repo Root"),
        default=REPO_ROOT_HEADER,
        help="\033[1;35mHeader text for files located in the root of the repository. Default is 'Repo Root'.\033[0m",
    )
    parser.add_argument(
        "--header_text",
        type=str,
        metavar=("## File List"),
        default=HEADER_TEXT,
        help="\033[1;36mHeader text for the file list displayed at the top of the generated HTML file. Default is '## File List'.\033[0m",
    )
    parser.add_argument(
        "--intro_text",
        type=str,
        metavar=("# Here is a list of files included in this repository:"),
        default=INTRO_TEXT,
        help="\033[1;33mIntroductory text for the file list displayed below the header in the generated HTML file. Default is '# Here is a list of files included in this repository:'.\033[0m",
    )
    parser.add_argument(
        "--dark_color_luminance_threshold",
        type=int,
        metavar=(128),
        default=DARK_COLOR_LUMINANCE_THRESHOLD,
        help="\033[1;32mLuminance threshold for determining if a color is dark. Colors with luminance below this value will be considered dark. Default is 128.\033[0m",
    )
    parser.add_argument(
        "--bright_color_luminance_threshold",
        type=int,
        metavar=(200),
        default=BRIGHT_COLOR_LUMINANCE_THRESHOLD,
        help="\033[1;31mLuminance threshold for determining if a color is bright. Colors with luminance above this value will be considered bright. Default is 200.\033[0m",
    )
    parser.add_argument(
        "--chunk_size",
        type=int,
        metavar=(40),
        default=CHUNK_SIZE,
        help="\033[1;34mNumber of lines per chunk for lazy loading the file list. Default is 40 lines per chunk.\033[0m",
    )

    args = parser.parse_args()

    if args.color_range:
        try:
            if not all(
                color.startswith("#")
                and len(color) == 7
                and all(c in "0123456789abcdefABCDEF" for c in color[1:])
                for color in args.color_range
            ):
                raise ValueError(
                    "\033[1;31mInvalid color code(s). Color codes must be in hex format (#RRGGBB).\033[0m"
                )
        except ValueError as e:
            logging.error(e)
            exit(1)

    # Only override the default value if the argument is provided
    if args.log_level:
        LOG_LEVEL_SETTING = args.log_level
    if args.directory:
        ROOT_DIRECTORY = args.directory
    if args.repo_url:
        DEFAULT_GIT_REPO_URL = args.repo_url
    if args.fallback_repo_url:
        FALLBACK_REPO_URL = args.fallback_repo_url
    if args.output_file:
        DEFAULT_OUTPUT_FILE = args.output_file
    if args.color_source:
        DEFAULT_COLOR_SOURCE = args.color_source
    if args.color_range:
        DEFAULT_COLOR_RANGE = args.color_range
    if args.exclude_dark_colors:
        EXCLUDE_DARK_COLORS = args.exclude_dark_colors
    if args.exclude_bright_colors:
        EXCLUDE_BRIGHT_COLORS = args.exclude_bright_colors
    if args.exclude_blacks:
        EXCLUDE_BLACKS = args.exclude_blacks
    if args.max_attempts:
        MAX_ATTEMPTS = args.max_attempts
    if args.exclude_blacks_threshold:
        EXCLUDE_BLACKS_THRESHOLD = args.exclude_blacks_threshold
    if args.ensure_readable_colors:
        ENSURE_READABLE_COLORS = args.ensure_readable_colors
    if args.repo_root_header:
        REPO_ROOT_HEADER = args.repo_root_header
    if args.header_text:
        HEADER_TEXT = args.header_text
    if args.intro_text:
        INTRO_TEXT = args.intro_text
    if args.dark_color_luminance_threshold:
        DARK_COLOR_LUMINANCE_THRESHOLD = args.dark_color_luminance_threshold
    if args.bright_color_luminance_threshold:
        BRIGHT_COLOR_LUMINANCE_THRESHOLD = args.bright_color_luminance_threshold
    if args.chunk_size:
        CHUNK_SIZE = args.chunk_size

    # Log the values of all arguments
    logging.info(f"\033[1;32mStarting script with arguments:\033[0m {args}")
    logging.info(f"\033[1;94mLOG_LEVEL is set to:\033[0m {args.log_level}")
    logging.info(
        f"\033[1;94mREPO_ROOT_HEADER is set to:\033[0m {args.repo_root_header}"
    )
    logging.info(f"\033[1;95mHEADER_TEXT is set to:\033[0m {args.header_text}")
    logging.info(f"\033[1;96mINTRO_TEXT is set to:\033[0m {args.intro_text}")

    logging.info(f"\033[1;32mCHUNK_SIZE is set to:\033[0m {args.chunk_size}")
    logging.info(f"\033[1;32mDIRECTORY is set to:\033[0m {args.directory}")
    logging.info(f"\033[1;33mREPO_URL is set to:\033[0m {args.repo_url}")
    logging.info(
        f"\033[1;34mFALLBACK_REPO_URL is set to:\033[0m {args.fallback_repo_url}"
    )
    logging.info(
        f"\033[1;35mCOLOR_SOURCE is set to:\033[0m {args.color_source}")
    logging.info(f"\033[1;36mCOLOR_RANGE is set to:\033[0m {args.color_range}")
    logging.info(
        f"\033[1;93mEXCLUDE_DARK_COLORS is set to:\033[0m {args.exclude_dark_colors}"
    )
    logging.info(
        f"\033[1;93mDARK_COLOR_LUMINANCE_THRESHOLD is set to:\033[0m {args.dark_color_luminance_threshold}"
    )
    logging.info(
        f"\033[1;91mEXCLUDE_BRIGHT_COLORS is set to:\033[0m {args.exclude_bright_colors}"
    )
    logging.info(
        f"\033[1;31mBRIGHT_COLOR_LUMINANCE_THRESHOLD is set to:\033[0m {args.bright_color_luminance_threshold}"
    )
    logging.info(
        f"\033[1;35mEXCLUDE_BLACKS is set to:\033[0m {args.exclude_blacks}")
    logging.info(
        f"\033[1;35mEXCLUDE_BLACKS_THRESHOLD is set to:\033[0m {args.exclude_blacks_threshold}"
    )
    logging.info(
        f"\033[1;35mMAX_ATTEMPTS is set to:\033[0m {args.max_attempts}")
    logging.info(
        f"\033[1;93mENSURE_READABLE_COLORS is set to:\033[0m {args.ensure_readable_colors}"
    )

    file_list = generate_file_list(args.directory, IGNORE_LIST)
    file_list_html = generate_file_list_with_links(
        file_list,
        args.repo_url if args.repo_url else args.fallback_repo_url,
        args.color_source,
        args.color_range,
        args.color_list,
    )
    save_file_list(file_list_html, args.output_file)

    logging.info("\033[1;32mScript finished.\033[0m")
