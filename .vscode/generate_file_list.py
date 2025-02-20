"""
This script generates an HTML file containing a list of files from a specified directory,
with links to their corresponding locations in a GitHub repository.

The script can be configured to:
- Use a default or custom GitHub repository URL.
- Specify the output file name.
- Choose the source of the link colors (random or from a list).
- Define a color range for random color generation.
- Exclude dark, bright, or black colors.
- Ensure the generated colors are readable.

The script categorizes files based on their extensions (e.g., userstyles, userscripts, CSS)
and generates HTML links for each file, sorted by category and folder.

It uses the following modules:
- os: For interacting with the operating system, such as walking through directories.
- random: For generating random colors.
- urllib.parse: For encoding URLs.
- logging: For logging script activity and errors.
- argparse: For parsing command-line arguments.
- collections.defaultdict: For creating dictionaries with default values for keys.

The script defines several functions:
- should_ignore: Checks if a given path should be ignored based on the ignore list.
- generate_file_list: Generates a list of files in a directory, excluding those in the ignore list.
- is_dark_color: Determines if a color is dark based on its hex value.
- is_bright_color: Determines if a color is bright based on its hex value.
- is_readable_color: Determines if a color is readable based on its contrast with a white background.
- get_random_color: Generates a random hexadecimal color code, optionally within a specified range.
- generate_file_list_with_links: Generates a list of HTML links for the given file list, with customizable colors.
- save_file_list: Saves the list of HTML links to a file.

The script's main entry point parses command-line arguments, generates the file list with HTML links,
and saves the output to a file.
"""

import os
import random
import urllib.parse
import logging
import argparse
import math
from collections import defaultdict

# --- Configuration ---
# Default GitHub repository URL
# Specifies the default URL of the GitHub repository.
DEFAULT_GIT_REPO_URL = "https://github.com/Nick2bad4u/Userstyles"

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
DEFAULT_COLOR_LIST = ["#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF"]

# Color range
# Specifies the range of colors for random color generation.
# This should be a tuple of two hexadecimal color codes representing the lower and upper bounds of the range.
# Default value is None, which indicates the full random range.
# Example: DEFAULT_COLOR_RANGE = ("#000000", "#FFFFFF")
DEFAULT_COLOR_RANGE = None

# Ignore list
# Specifies a list of files and folders to ignore during the directory walk.
IGNORE_LIST = [".git", "node_modules", ".DS_Store", ".history", "styles", "zwiftbikes"]

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

# If set to True, ensures that the generated colors are readable by maintaining a certain contrast ratio with a white background.
ENSURE_READABLE_COLORS = True

# --- End Configuration ---

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


def should_ignore(path, ignore_list):
    try:
        path_parts = set(path.split(os.sep))
        return any(ignore_item in path_parts for ignore_item in ignore_list)
    except Exception as e:
        logging.error(f"Error in should_ignore function: {e}")
        return False


def generate_file_list(directory, ignore_list):
    file_list = set()
    try:
        for root, dirs, files in os.walk(directory):
            # Filter directories in-place to avoid walking into ignored directories
            dirs[:] = list(
                filter(
                    lambda d: not should_ignore(os.path.join(root, d), ignore_list),
                    dirs,
                )
            )
            for file in files:
                file_path = os.path.join(root, file)
                ignore_file = should_ignore(file_path, ignore_list)
                if not ignore_file:
                    file_list.add(os.path.relpath(file_path, directory))
        logging.info(f"Generated file list with {len(file_list)} files.")
    except (OSError, ValueError) as e:
        logging.error(f"Error generating file list: {type(e).__name__}: {e}")
    return list(file_list)


def calculate_luminance(hex_color):
    try:
        r, g, b = [int(hex_color[i : i + 2], 16) for i in (1, 3, 5)]
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    except ValueError as e:
        logging.error(f"Error calculating luminance for color {hex_color}: {e}")
        return 0


def is_dark_color(hex_color):
    try:
        luminance = calculate_luminance(hex_color)
        return luminance < DARK_COLOR_LUMINANCE_THRESHOLD
    except Exception as e:
        logging.error(f"Error in is_dark_color function: {e}")
        return False


def is_bright_color(hex_color):
    try:
        luminance = calculate_luminance(hex_color)
        return luminance > BRIGHT_COLOR_LUMINANCE_THRESHOLD
    except Exception as e:
        logging.error(f"Error in is_bright_color function: {e}")
        return False


def is_readable_color(hex_color):
    try:
        luminance = calculate_luminance(hex_color)
        return 50 < luminance < 200
    except Exception as e:
        logging.error(f"Error in is_readable_color function: {e}")
        return False


def get_random_color(color_range=None):
    """
    Generates a random color (in hex) within the specified range if provided,
    avoiding excluded colors.
    """
    max_attempts = 100
    if color_range and any(
        int(color_range[0][i : i + 2], 16) > int(color_range[1][i : i + 2], 16)
        for i in range(1, 7, 2)
    ):
        logging.error(
            f"Invalid color range: {color_range[0]} should be <= {color_range[1]}"
        )
        return "#000000"
    for _ in range(max_attempts):
        if color_range:
            r_min, g_min, b_min = [
                int(color_range[0][i : i + 2], 16) for i in (1, 3, 5)
            ]
            r_max, g_max, b_max = [
                int(color_range[1][i : i + 2], 16) for i in (1, 3, 5)
            ]
            r = random.randint(r_min, r_max)
            g = random.randint(g_min, g_max)
            b = random.randint(b_min, b_max)
            color = f"#{r:02x}{g:02x}{b:02x}"
        else:
            color = f"#{random.randint(0, 0xFFFFFF):06x}"
        if not should_exclude_color(color):
            return color
    logging.error("Failed to generate a valid color within max attempts.")
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

        logging.info(f"Generated HTML links for {len(file_list)} files.")
    except (OSError, ValueError, KeyError) as e:
        logging.error(f"Error generating HTML links: {type(e).__name__}: {e}")

    sorted_html = []

    root_files = []
    if "" in file_list_html:
        root_files = file_list_html.pop("")

    if root_files:
        sorted_html.append(f"<li><h2>{REPO_ROOT_HEADER}</h2></li>")
        sorted_html.extend(sorted(root_files, key=lambda x: os.path.splitext(x)[1]))

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
        logging.info(f"File list saved to {output_file}")
    except (IOError, OSError) as e:
        logging.error(f"Error saving file list to {output_file}: {e}", exc_info=True)


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
        "--color_list",
        nargs="+",
        metavar="COLOR",
        default=DEFAULT_COLOR_LIST,
        help="List of colors to use when color source is 'list'",
    )
    parser.add_argument(
        "--directory",
        default=ROOT_DIRECTORY,
        metavar="DIRECTORY",
        help="Root directory of the repository",
    )
    parser.add_argument(
        "--repo_url",
        default=DEFAULT_GIT_REPO_URL,
        metavar="REPO_URL",
        help="GitHub repository URL",
    )

    parser.add_argument(
        "--output_file",
        default=DEFAULT_OUTPUT_FILE,
        metavar="OUTPUT_FILE.html",
        help="Output file name",
    )
    parser.add_argument(
        "--color_source",
        choices=["random", "list"],
        default=DEFAULT_COLOR_SOURCE,
        help="Color source: 'random' or 'list'",
    )
    parser.add_argument(
        "--color_range",
        nargs=2,
        metavar=("COLOR_MIN", "COLOR_MAX"),
        default=DEFAULT_COLOR_RANGE,
        help="Color range (hex codes) for random color generation (e.g., --color_range #000000 #FFFFFF)",
    )
    parser.add_argument(
        "--exclude_dark_colors",
        action="store_true",
        default=EXCLUDE_DARK_COLORS,
        help="Exclude dark colors: True or False",
    )
    parser.add_argument(
        "--exclude_bright_colors",
        action="store_true",
        default=EXCLUDE_BRIGHT_COLORS,
        help="Exclude bright colors: True or False",
    )
    parser.add_argument(
        "--exclude_blacks",
        action="store_true",
        default=EXCLUDE_BLACKS,
        help="Exclude black color (below the threshhold): True or False",
    )
    parser.add_argument(
        "--exclude_blacks_threshold",
        type=str,
        metavar=("#222222"),
        default=EXCLUDE_BLACKS_THRESHOLD,
        help="Excludes all black colors below this point on the color chart vertically. Example: #222222",
    )
    parser.add_argument(
        "--ensure_readable_colors",
        action="store_true",
        default=ENSURE_READABLE_COLORS,
        help="Ensure colors are readable: True or False",
    )
    parser.add_argument(
        "--repo_root_header",
        type=str,
        metavar=("Repo Root"),
        default=REPO_ROOT_HEADER,
        help="Header text for files in the repository root.",
    )
    parser.add_argument(
        "--header_text",
        type=str,
        metavar=("## File List"),
        default=HEADER_TEXT,
        help="Header text for the file list.",
    )
    parser.add_argument(
        "--intro_text",
        type=str,
        metavar=("# Here is a list of files included in this repository:"),
        default=INTRO_TEXT,
        help="Introductory text for the file list.",
    )
    parser.add_argument(
        "--dark_color_luminance_threshold",
        type=int,
        metavar=(128),
        default=DARK_COLOR_LUMINANCE_THRESHOLD,
        help="Luminance threshold for determining if a color is dark.",
    )
    parser.add_argument(
        "--bright_color_luminance_threshold",
        type=int,
        metavar=(200),
        default=BRIGHT_COLOR_LUMINANCE_THRESHOLD,
        help="Luminance threshold for determining if a color is bright.",
    )
    parser.add_argument(
        "--chunk_size",
        type=int,
        metavar=(40),
        default=CHUNK_SIZE,
        help="Number of lines per chunk for lazy loading.",
    )

    args = parser.parse_args()

    logging.info(f"Starting script with arguments: {args}")

    if args.color_range:
        try:
            if not all(
                color.startswith("#")
                and len(color) == 7
                and all(c in "0123456789abcdefABCDEF" for c in color[1:])
                for color in args.color_range
            ):
                raise ValueError(
                    "Invalid color code(s). Color codes must be in hex format (#RRGGBB)."
                )
        except ValueError as e:
            logging.error(e)
            exit(1)

    # Only override the default value if the argument is provided
    if args.directory:
        ROOT_DIRECTORY = args.directory
    if args.repo_url:
        DEFAULT_GIT_REPO_URL = args.repo_url
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
    logging.info(f"EXCLUDE_BLACKS_THRESHOLD is set to: {args.exclude_blacks_threshold}")
    logging.info(f"DIRECTORY is set to: {args.directory}")
    logging.info(f"REPO_URL is set to: {args.repo_url}")
    logging.info(f"COLOR_SOURCE is set to: {args.color_source}")
    logging.info(f"COLOR_RANGE is set to: {args.color_range}")
    logging.info(f"EXCLUDE_DARK_COLORS is set to: {args.exclude_dark_colors}")
    logging.info(f"EXCLUDE_BRIGHT_COLORS is set to: {args.exclude_bright_colors}")
    logging.info(f"EXCLUDE_BLACKS is set to: {args.exclude_blacks}")
    logging.info(f"ENSURE_READABLE_COLORS is set to: {args.ensure_readable_colors}")
    logging.info(f"REPO_ROOT_HEADER is set to: {args.repo_root_header}")
    logging.info(f"HEADER_TEXT is set to: {args.header_text}")
    logging.info(f"INTRO_TEXT is set to: {args.intro_text}")
    logging.info(
        f"DARK_COLOR_LUMINANCE_THRESHOLD is set to: {args.dark_color_luminance_threshold}"
    )
    logging.info(
        f"BRIGHT_COLOR_LUMINANCE_THRESHOLD is set to: {args.bright_color_luminance_threshold}"
    )
    logging.info(f"CHUNK_SIZE is set to: {args.chunk_size}")

    file_list = generate_file_list(args.directory, IGNORE_LIST)
    file_list_html = generate_file_list_with_links(
        file_list,
        args.repo_url,
        args.color_source,
        args.color_range,
        args.color_list,
    )
    save_file_list(file_list_html, args.output_file)

    logging.info("Script finished.")
