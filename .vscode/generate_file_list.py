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
HEADER_TEXT = "File List"

# INTRO_TEXT determines the introductory text for the file list.
# This is displayed below the header in the generated HTML file.
INTRO_TEXT = "Here is a list of files included in this repository:"


# Color exclusion options
# If set to True, excludes dark colors from being used.
EXCLUDE_DARK_COLORS = False

# If set to True, excludes bright colors from being used.
EXCLUDE_BRIGHT_COLORS = False

# If set to True, excludes black color from being used.
EXCLUDE_BLACKS = True

# If set to True, ensures that the generated colors are readable by maintaining a certain contrast ratio with a white background.
ENSURE_READABLE_COLORS = True

# --- End Configuration ---

# Configure logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


def should_ignore(path, ignore_list):
    """Checks if a given path should be ignored based on the ignore list."""
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


def is_dark_color(hex_color):
    """Determines if a color is dark based on its hex value."""
    r, g, b = tuple(int(hex_color[i : i + 2], 16) for i in (1, 3, 5))
    luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
    return luminance < 128


def is_bright_color(hex_color):
    """Determines if a color is bright based on its hex value."""
    r, g, b = tuple(int(hex_color[i : i + 2], 16) for i in (1, 3, 5))
    luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
    return luminance > 200


def is_readable_color(hex_color):
    """Determines if a color is readable based on its contrast with a white background."""
    r, g, b = tuple(int(hex_color[i : i + 2], 16) for i in (1, 3, 5))
    luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
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

    regular_folders = [
        folder for folder in sorted(file_list_html) if not folder.startswith(".")
    ]
    dot_folders = [
        folder for folder in sorted(file_list_html) if folder.startswith(".")
    ]

    def sort_files_by_extension(files):
        return sorted(files, key=lambda x: os.path.splitext(x)[1])

    for folder in regular_folders:
        sorted_html.append(f"<li><h2>{folder}</h2></li>")
        sorted_html.extend(sort_files_by_extension(file_list_html[folder]))

    for folder in dot_folders:
        sorted_html.append(f"<li><h2>{folder}</h2></li>")
        sorted_html.extend(sort_files_by_extension(file_list_html[folder]))

    sorted_html.append("</ul>")

    return "\n".join(sorted_html)


def save_file_list(file_list_html, output_file, chunk_size=100):
    """Saves the list of HTML links to a file with lazy loading."""
    file_list_html = file_list_html.replace("\\", "/")
    file_list_chunks = []
    current_chunk = []
    for line in file_list_html.splitlines():
        current_chunk.append(line)
        if len(current_chunk) >= chunk_size:
            file_list_chunks.append("\n".join(current_chunk))
            current_chunk = []
    if current_chunk:
        file_list_chunks.append("\n".join(current_chunk))

    try:
        with open(output_file, "w") as f:
            f.write(f"<h1>{HEADER_TEXT}</h1>\n\n")
            f.write(f"<p>{INTRO_TEXT}</p>\n\n")
            for i in range(len(file_list_chunks)):
                f.write(
                    f'<div class="lazyload-placeholder" data-content="file-list-{i+1}"></div>\n'
                )

            # Add lazy loading script
            f.write(
                """
<script>
document.addEventListener("DOMContentLoaded", function() {
    const lazyLoadElements = document.querySelectorAll('.lazyload-placeholder');

    if ("IntersectionObserver" in window) {
        let observer = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    let placeholder = entry.target;
                    let contentId = placeholder.dataset.content;
                    let file_list_html = '';
                    switch(contentId) {
"""
            )
            for i in range(len(file_list_chunks)):
                f.write(
                    f"""
                        case 'file-list-{i+1}':
                            file_list_html = `{file_list_chunks[i].replace('`', '`')}`
                            break;"""
                )
            f.write(
                """
                    }
                    placeholder.innerHTML = file_list_html;
                    observer.unobserve(placeholder);
                }
            });
        });

        lazyLoadElements.forEach(element => {
            observer.observe(element);
        });
    } else {
        // Fallback for browsers without IntersectionObserver support
        lazyLoadElements.forEach(placeholder => {
            let contentId = placeholder.dataset.content;
            let file_list_html = '';
            switch(contentId) {
"""
            )
            for i in range(len(file_list_chunks)):
                f.write(
                    f"""
                case 'file-list-{i+1}':
                    file_list_html = `{file_list_chunks[i].replace('`', '`')}`
                    break;"""
                )
            f.write(
                """
            }
            placeholder.innerHTML = file_list_html;
        });
    }
});
</script>
"""
            )
        logging.info(f"File list saved to {output_file}")
    except Exception as e:
        logging.error(f"Error saving file list to {output_file}: {e}")


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
            for color in args.color_range:
                if not (
                    color.startswith("#")
                    and len(color) == 7
                    and all(c in "0123456789abcdefABCDEF" for c in color[1:])
                ):
                    raise ValueError(
                        f"Invalid color code: {color}. Color codes must be in hex format (#RRGGBB)."
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
        file_list, args.repo_url, args.color_source, args.color_range
    )
    save_file_list(file_list_html, args.output_file)

    logging.info("Script finished.")
