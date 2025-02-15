import os
import random
import urllib.parse
import logging
import argparse
from collections import defaultdict

# --- Configuration ---
# Default GitHub repository URL
GIT_REPO_URL = "https://github.com/Nick2bad4u/Userstyles"
# Output file name
OUTPUT_FILE = "file_list.html"
# Color source: 'random' or 'list'
COLOR_SOURCE = "random"
# Color range (hex codes) for random color generation (e.g., COLOR_MIN, COLOR_MAX)
# Example: COLOR_RANGE = ("#000000", "#FFFFFF")
# Set to None for full random range
COLOR_RANGE = None

# Predefined color list for 'list' color source
COLOR_LIST = ["#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF"]

# List of files and folders to ignore
IGNORE_LIST = [
    ".git",
    "node_modules",  # npm
    ".DS_Store",  # macOS
    ".history",
    "styles",
    "zwiftbikes",
]

# --- End Configuration ---

# Configure logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


def should_ignore(path, ignore_list):
    """
    Checks if a given path should be ignored based on the ignore list.

    Args:
        path (str): The path to check.
        ignore_list (list): A list of items to ignore.

    Returns:
        bool: True if the path should be ignored, False otherwise.
    """
    try:
        for ignore_item in ignore_list:
            if ignore_item in path.split(os.sep):
                return True
        return False
    except Exception as e:
        logging.error(f"Error checking ignore status for path {path}: {e}")
        return False  # Default to not ignoring on error


def generate_file_list(directory, ignore_list):
    """
    Generates a list of files in a directory, excluding those in the ignore list.

    Args:
        directory (str): The root directory to walk.
        ignore_list (list): A list of files and directories to ignore.

    Returns:
        list: A list of file paths relative to the directory.
    """
    file_list = []
    try:
        for root, dirs, files in os.walk(directory):
            for file in files:
                file_path = os.path.relpath(os.path.join(root, file), directory)
                # Ignore specified files and folders
                if not should_ignore(file_path, ignore_list):
                    file_list.append(file_path)
        logging.info(f"Generated file list with {len(file_list)} files.")
    except Exception as e:
        logging.error(f"Error generating file list: {e}")
    return file_list


def get_random_color(color_range=None):
    """
    Generates a random hexadecimal color code, optionally within a specified range.

    Args:
        color_range (tuple, optional): A tuple of two hexadecimal color codes
            representing the lower and upper bounds of the color range.
            Defaults to None, which means the full color range (000000 to FFFFFF).

    Returns:
        str: A random hexadecimal color code.
    """
    try:
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

            return "#{:02x}{:02x}{:02x}".format(r, g, b)
        else:
            return "#{:06x}".format(random.randint(0, 0xFFFFFF))
    except Exception as e:
        logging.error(f"Error generating random color: {e}")
        return "#000000"  # Default to black on error


def generate_file_list_with_links(
    file_list, repo_url, color_source="random", color_range=None
):
    """
    Generates a list of HTML links for the given file list, with customizable colors.

    Args:
        file_list (list): A list of file paths.
        repo_url (str): The base URL of the GitHub repository.
        color_source (str, optional): 'random' for random colors, 'list' for predefined colors. Defaults to 'random'.
        color_range (tuple, optional): A tuple of two hexadecimal color codes
            representing the lower and upper bounds of the color range.
            Required if you want a range to random colors.

    Returns:
        str: An HTML string containing the file list grouped by folder.
    """
    file_list_html = defaultdict(list)
    top_folder = []
    second_folder = []
    third_folder = []
    file_extension_top_folder_ext = ".user.css"
    file_extension_top_folder_name = "<h2>Userstyles</h2>"
    file_extension_second_folder_ext = ".user.js"
    file_extension_second_folder_name = "<h2>Userscripts</h2>"
    file_extension_third_folder_ext = ".css"
    file_extension_third_folder_name = "<h2>CSS</h2>"
    try:
        for file in file_list:
            file_url = f"{repo_url}/blob/main/{file}".replace("\\", "/")
            # Encode spaces and special characters
            file_url = urllib.parse.quote(file_url, safe="/:")

            if color_source == "random":
                color = get_random_color(color_range)
            elif color_source == "list":
                color = random.choice(COLOR_LIST)
            else:
                color = "#000000"  # Default to black


            if file.endswith(file_extension_top_folder_ext):
                top_folder.append(
                    f'<a href="{file_url}" style="color: {color};">{file}</a>'
                )
            elif file.endswith(file_extension_second_folder_ext):
                second_folder.append(
                    f'<a href="{file_url}" style="color: {color};">{file}</a>'
                )
            elif file.endswith(file_extension_third_folder_ext):
                third_folder.append(
                    f'<a href="{file_url}" style="color: {color};">{file}</a>'
                )
            else:
                folder = os.path.dirname(file)
                file_list_html[folder].append(
                    f'<a href="{file_url}" style="color: {color};">{file}</a>'
                )
        logging.info(f"Generated HTML links for {len(file_list)} files.")
    except Exception as e:
        logging.error(f"Error generating HTML links: {e}")

    sorted_html = []

    if top_folder:
        sorted_html.append(file_extension_top_folder_name)
        sorted_html.extend(f"<li>{file}</li>" for file in sorted(top_folder))

    if second_folder:
        sorted_html.append(file_extension_second_folder_name)
        sorted_html.extend(f"<li>{file}</li>" for file in sorted(second_folder))

    if third_folder:
        sorted_html.append(file_extension_third_folder_name)
        sorted_html.extend(f"<li>{file}</li>" for file in sorted(third_folder))

    # Separate folders starting with a dot (.)
    regular_folders = [
        folder for folder in sorted(file_list_html) if not folder.startswith(".")
    ]
    dot_folders = [
        folder for folder in sorted(file_list_html) if folder.startswith(".")
    ]

    def sort_files_by_extension(files):
        return sorted(files, key=lambda x: os.path.splitext(x)[1])

    # Process regular folders first
    for folder in regular_folders:
        sorted_html.append(f"<h2>{folder}</h2>")
        sorted_html.extend(
            f"<li>{file}</li>"
            for file in sort_files_by_extension(file_list_html[folder])
        )

    # Process dot folders after regular folders
    for folder in dot_folders:
        sorted_html.append(f"<h2>{folder}</h2>")
        sorted_html.extend(
            f"<li>{file}</li>"
            for file in sort_files_by_extension(file_list_html[folder])
        )

    return "\n".join(sorted_html)


def save_file_list(file_list_html, output_file):
    """
    Saves the list of HTML links to a file.

    Args:
        file_list_html (str): An HTML string containing the file list grouped by folder.
        output_file (str): The path to the output file.
    """
    try:
        with open(output_file, "w") as f:
            f.write("## File List\n\n")
            f.write("<p> # Here is a list of files included in this repository:</p>\n\n")
            f.write("<ul>")
            f.write(file_list_html)
            f.write("</ul>")
        logging.info(f"File list saved to {output_file}")
    except Exception as e:
        logging.error(f"Error saving file list to {output_file}: {e}")


if __name__ == "__main__":
    # Set up argument parser
    parser = argparse.ArgumentParser(
        description="Generate a file list for a GitHub repository with HTML links."
    )
    parser.add_argument(
        "--directory", default=".", help="Root directory of the repository"
    )
    parser.add_argument(
        "--repo_url", default=GIT_REPO_URL, help="GitHub repository URL"
    )
    parser.add_argument("--output_file", default=OUTPUT_FILE, help="Output file name")
    parser.add_argument(
        "--color_source",
        choices=["random", "list"],
        default=COLOR_SOURCE,
        help="Color source: 'random' or 'list'",
    )
    parser.add_argument(
        "--color_range",
        nargs=2,
        metavar=("COLOR_MIN", "COLOR_MAX"),
        help="Color range (hex codes) for random color generation (e.g., --color_range #000000 #FFFFFF)",
    )

    args = parser.parse_args()

    logging.info(f"Starting script with arguments: {args}")

    # Validate color range if provided
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
        COLOR_RANGE = tuple(args.color_range)
    DIRECTORY = args.directory
    GIT_REPO_URL = args.repo_url
    OUTPUT_FILE = args.output_file
    COLOR_SOURCE = args.color_source

    # Run the script
    file_list = generate_file_list(DIRECTORY, IGNORE_LIST)
    file_list_html = generate_file_list_with_links(
        file_list, GIT_REPO_URL, COLOR_SOURCE, COLOR_RANGE
    )
    save_file_list(file_list_html, OUTPUT_FILE)

    logging.info("Script finished.")
