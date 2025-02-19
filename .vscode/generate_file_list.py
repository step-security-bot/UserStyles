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
# Luminance threshold for determining if a color is dark
DARK_COLOR_LUMINANCE_THRESHOLD = 128

# If set to True, excludes bright colors from being used.
EXCLUDE_BRIGHT_COLORS = False
# Luminance threshold for determining if a color is bright
BRIGHT_COLOR_LUMINANCE_THRESHOLD = 200

# If set to True, excludes black color from being used.
EXCLUDE_BLACKS = True

# If set to True, ensures that the generated colors are readable by maintaining a certain contrast ratio with a white background.
ENSURE_READABLE_COLORS = True

# --- End Configuration ---

# Configure logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


def should_ignore(path: str, ignore_list: list) -> bool:
    """Checks if a given path should be ignored based on the ignore list.

    Args:
        path (str): The file or directory path to check.
        ignore_list (list): A list of strings representing files or directories to ignore.

    Returns:
        bool: True if the path should be ignored, False otherwise.
    """
    return any(ignore_item in path.split(os.sep) for ignore_item in ignore_list)


def generate_file_list(directory, ignore_list):
    """Generates a list of files in a directory, excluding those in the ignore list."""
    file_list = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            if not should_ignore(file_path, ignore_list):
                file_list.append(os.path.relpath(file_path, directory))
    logging.info(f"Generated file list with {len(file_list)} files.")
    return file_list


def calculate_luminance(hex_color):
    """Calculates the luminance of a color based on its hex value.

    Args:
        hex_color (str): The hexadecimal color code (e.g., "#RRGGBB").

    Returns:
        float: The luminance of the color.
    """
    r, g, b = [int(hex_color[i : i + 2], 16) / 255.0 for i in (1, 3, 5)]
    r, g, b = r / 255.0, g / 255.0, b / 255.0
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def is_dark_color(hex_color):
    """Determines if a color is dark based on its hex value.

    Args:
        hex_color (str): The hexadecimal color code (e.g., "#RRGGBB").

    Returns:
        bool: True if the color is dark, False otherwise.

    Note:
        A color is considered dark if its luminance is below DARK_COLOR_LUMINANCE_THRESHOLD.
    """
    luminance = calculate_luminance(hex_color)
    return luminance < DARK_COLOR_LUMINANCE_THRESHOLD


def is_bright_color(hex_color):
    """Determines if a color is bright based on its hex value."""
    luminance = calculate_luminance(hex_color)
    return luminance > BRIGHT_COLOR_LUMINANCE_THRESHOLD


def is_readable_color(hex_color):
    """Determines if a color is readable based on its contrast with a white background."""
    luminance = calculate_luminance(hex_color)
    return 50 < luminance < 200


def get_random_color(color_range=None):
    """Generates a random hexadecimal color code, optionally within a specified range."""
    while True:
        if color_range:
            r_min, g_min, b_min = (
                int(color_range[0][i : i + 2], 16) for i in (1, 3, 5)
            )
            r_max, g_max, b_max = (
                int(color_range[1][i : i + 2], 16) for i in (1, 3, 5)
            )

            r = random.randint(r_min, r_max)
            g = random.randint(g_min, g_max)
            b = random.randint(b_min, b_max)

            color = "#{:02x}{:02x}{:02x}".format(r, g, b)
        else:
            color = "#{:06x}".format(random.randint(0, 0xFFFFFF))

        if EXCLUDE_DARK_COLORS and is_dark_color(color):
            continue
        if EXCLUDE_BRIGHT_COLORS and is_bright_color(color):
            continue
        if EXCLUDE_BLACKS and color.lower() == "#000000":
            continue
        if ENSURE_READABLE_COLORS and not is_readable_color(color):
            continue

        return color


def generate_file_list_with_links(
    file_list, repo_url, color_source="random", color_range=None, color_list=None
):
    """Generates a list of HTML links for the given file list, with customizable colors."""
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
                color = "#000000"  # Default to black

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
    # Catch and log any exceptions to ensure the script continues running even if an error occurs.
    except Exception as e:
        logging.error(f"Error generating HTML links: {e}")

    sorted_html = ["<ul>"]

    for category in FILE_CATEGORIES:
        if category["files"]:
            sorted_html.append(f'<li><h2>{category["name"]}</h2></li>')
            sorted_html.extend(sorted(category["files"]))

    # Collect files without a folder
    root_files = []
    if "" in file_list_html:
        root_files = file_list_html.pop("")

    sorted_html = ["<ul>"]

    # Add files without a folder under a "Root" header
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
    """Sorts a list of files by their extension."""
    return sorted(files, key=lambda x: os.path.splitext(x)[1])


# The HTML content is split into chunks for lazy loading.
# This allows the page to load faster by loading the content in smaller pieces.


def save_file_list(file_list_html, output_file):
    """Saves the list of HTML links to a file with lazy loading.

    Args:
            file_list_html (str): The HTML content of the file list.
            output_file (str): The name of the output file.
    """
    file_list_html = file_list_html.replace("\\", "/")
    file_list_chunks = split_into_chunks(file_list_html, CHUNK_SIZE)

    try:
        with open(output_file, "w") as f:
            write_html_header(f)
            write_lazyload_placeholders(f, file_list_chunks)
            write_lazyload_script(f, file_list_chunks)
        logging.info(f"File list saved to {output_file}")
    except Exception as e:
        logging.error(f"Error saving file list to {output_file}: {e}")


def split_into_chunks(file_list_html, chunk_size):
    """Splits the file list HTML into smaller chunks for lazy loading.

    Args:
        file_list_html (str): The HTML content of the file list.
        chunk_size (int): The number of lines per chunk.

    Returns:
        list: A list of HTML chunks, each containing up to chunk_size lines.

    Purpose:
        Chunking the HTML content allows for lazy loading, which improves page load performance
        by loading the content in smaller pieces as needed, rather than all at once.
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
    """Writes the HTML header to the file.

    Args:
        f (file object): The file object to write the HTML header to.
    """
    """Writes the HTML header to the file."""
    f.write(f"<h1>{HEADER_TEXT}</h1>\n\n")
    f.write(f"<p>{INTRO_TEXT}</p>\n\n")


def write_lazyload_placeholders(f, file_list_chunks):
    """Writes the lazy load placeholders to the file."""
    for i in range(len(file_list_chunks)):
        f.write(
            f'<div class="lazyload-placeholder" data-content="file-list-{i+1}"></div>\n'
        )


def write_lazyload_script(f, file_list_chunks):
    """Writes the lazy load script to the file."""
    f.write(
        "<script>\n"
        'document.addEventListener("DOMContentLoaded", function() {\n'
        "    const lazyLoadElements = document.querySelectorAll('.lazyload-placeholder');\n"
        "\n"
        '    if ("IntersectionObserver" in window) {\n'
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
            f'                            file_list_html = `{file_list_chunks[i]}`\n'
            f"                            break;\n"
        )
    f.write(
        "                    }\n"
        "                    placeholder.innerHTML = file_list_html;\n"
        "                    observer.unobserve(placeholder);\n"
        "                }\n"
        "            });\n"
        "        });\n"
        "\n"
        "        lazyLoadElements.forEach(element => {\n"
        "            observer.observe(element);\n"
        "        });\n"
        "    } else {\n"
        "        // Fallback for browsers without IntersectionObserver support\n"
        "        lazyLoadElements.forEach(placeholder => {\n"
        "            let contentId = placeholder.dataset.content;\n"
        "            let file_list_html = '';\n"
        "            switch(contentId) {\n"
    )
    for i in range(len(file_list_chunks)):
        f.write(
            f"                case 'file-list-{i+1}':\n"
            f'                    file_list_html = `{file_list_chunks[i]}`\n'
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
        "--directory", default=".", help="Root directory of the repository"
    )
    parser.add_argument(
        "--repo_url", default=DEFAULT_GIT_REPO_URL, help="GitHub repository URL"
    )
    parser.add_argument(
        "--output_file", default=DEFAULT_OUTPUT_FILE, help="Output file name"
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
        "--exclude_dark_colors", action="store_true", help="Exclude dark colors"
    )
    parser.add_argument(
        "--exclude_bright_colors", action="store_true", help="Exclude bright colors"
    )
    parser.add_argument(
        "--exclude_blacks", action="store_true", help="Exclude black color"
    )
    parser.add_argument(
        "--ensure_readable_colors",
        action="store_true",
        help="Ensure colors are readable",
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

    EXCLUDE_DARK_COLORS = args.exclude_dark_colors
    EXCLUDE_BRIGHT_COLORS = args.exclude_bright_colors
    EXCLUDE_BLACKS = args.exclude_blacks
    ENSURE_READABLE_COLORS = args.ensure_readable_colors

    file_list = generate_file_list(args.directory, IGNORE_LIST)
    file_list_html = generate_file_list_with_links(
        file_list,
        args.repo_url,
        args.color_source,
        args.color_range,
        DEFAULT_COLOR_LIST,
    )
    save_file_list(file_list_html, args.output_file)

    logging.info("Script finished.")
