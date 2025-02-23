"""_summary_
This script generates an HTML file list for a GitHub repository with links to each file.
It supports various configurations, including color customization, lazy loading, and file categorization.

Configuration:
- FALLBACK_REPO_URL: Fallback URL of the GitHub repository if the default URL cannot be determined.
- DEFAULT_GIT_REPO_URL: Default URL of the GitHub repository.
- ROOT_DIRECTORY: Root directory of the repository to generate the file list for.
- DEFAULT_OUTPUT_FILE: Default name of the output HTML file.
- DEFAULT_COLOR_SOURCE: Source of the colors used for the links ("random" or "list").
- DEFAULT_COLOR_LIST: List of predefined colors to choose from when the color source is set to "list".
- DEFAULT_COLOR_RANGE: Range of colors for random color generation.
- IGNORE_LIST: List of files and folders to ignore during the directory walk.
- CHUNK_SIZE: Number of lines per chunk for lazy loading.
- VIEWPORT_MOBILE, VIEWPORT_TABLET, VIEWPORT_SMALL_DESKTOP: Viewport sizes for different devices.
- ROOT_MARGIN_LARGE_DESKTOP, ROOT_MARGIN_SMALL_DESKTOP, ROOT_MARGIN_TABLET, ROOT_MARGIN_MOBILE: Root margins for the IntersectionObserver.
- FILE_CATEGORIES: Categories of files based on their extensions.
- REPO_ROOT_HEADER: Header text for files in the root of the repository.
- HEADER_TEXT: Header text for the file list.
- INTRO_TEXT: Introductory text for the file list.
- EXCLUDE_DARK_COLORS: Exclude dark colors from being used.
- DARK_COLOR_LUMINANCE_THRESHOLD: Luminance threshold for determining if a color is dark.
- EXCLUDE_BRIGHT_COLORS: Exclude bright colors from being used.
- BRIGHT_COLOR_LUMINANCE_THRESHOLD: Luminance threshold for determining if a color is bright.
- EXCLUDE_BLACKS: Exclude colors below the EXCLUDE_BLACKS_THRESHOLD color from being used.
- EXCLUDE_BLACKS_THRESHOLD: Threshold for excluding black colors.
- MAX_ATTEMPTS: Max attempts to try to find a color below the threshold.
- ENSURE_READABLE_COLORS: Ensure that the generated colors are readable by maintaining a certain contrast ratio with a white background.
- LOG_LEVEL_SETTING: Log level setting for the logger.

Command-line arguments:
- --log-level: Set the logging level setting manually instead of pulling from environment.
- --directory: Root directory of the repository to generate the file list for. Default is the current directory.
- --repo-url: GitHub repository URL to use for generating file links. Default is determined by the Git configuration.
- --fallback-repo-url: Fallback GitHub repository URL to use if the default URL cannot be determined.
- --output-file: Name of the output HTML file to save the generated file list. Default is 'file_list.html'.
- --color-source: Source of colors for the file links. Choose 'random' for randomly generated colors or 'list' to use a predefined list of colors.
- --color-list: List of colors to use when the color source is set to 'list'. Provide colors in hex format (e.g., #FF0000).
- --color-range: Range of colors (hex codes) for random color generation. Provide two hex codes representing the lower and upper bounds (e.g., --color-range #000000 #FFFFFF).
- --exclude-dark-colors: Exclude dark colors from being used for file links. Use this option to avoid dark colors.
- --exclude-bright-colors: Exclude bright colors from being used for file links. Use this option to avoid bright colors.
- --exclude-blacks: Exclude black colors below a certain threshold from being used for file links. Use this option to avoid very dark colors.
- --max-attempts: Maximum number of attempts to generate a valid color. Default is 100.
- --exclude-blacks-threshold: Threshold for excluding black colors. Any color below this threshold on the color chart will be excluded (e.g., #222222).
- --ensure-readable-colors: Ensure that the generated colors are readable by maintaining a certain contrast ratio with a white background.
- --repo-root-header: Header text for files located in the root of the repository. Default is 'Repo Root'.
- --header-text: Header text for the file list displayed at the top of the generated HTML file. Default is '## File List'.
- --intro-text: Introductory text for the file list displayed below the header in the generated HTML file. Default is '# Here is a list of files included in this repository:'.
- --dark-color-luminance-threshold: Luminance threshold for determining if a color is dark. Colors with luminance below this value will be considered dark. Default is 128.
- --bright-color-luminance-threshold: Luminance threshold for determining if a color is bright. Colors with luminance above this value will be considered bright. Default is 200.
- --chunk-size: Number of lines per chunk for lazy loading the file list. Default is 40 lines per chunk.
- --viewport-mobile: Viewport size for mobile devices in pixels. Default is 768.
- --viewport-tablet: Viewport size for tablets in pixels. Default is 1024.
- --viewport-small-desktop: Viewport size for small desktops in pixels. Default is 1440.
- --root-margin-large-desktop: Root margin for the IntersectionObserver for large desktop viewport. Default is '0px 0px 400px 0px'.
- --root-margin-small-desktop: Root margin for the IntersectionObserver for small desktops. Default is '0px 0px 300px 0px'.
- --root-margin-tablet: Root margin for the IntersectionObserver for tablets. Default is '0px 0px 200px 0px'.
- --root-margin-mobile: Root margin for the IntersectionObserver for mobile devices. Default is '0px 0px 100px 0px'.
- --file-categories: List of file categories to include in the file list. Provide pairs of file extensions and category names (e.g., --file-categories .py Python .js JavaScript).
- --overwrite-file-categories: Overwrite the default file categories with the provided ones.
- --ignore-list: List of files and folders to ignore during the directory walk. Default is ['.git', 'node_modules', '.DS_Store', '.history', 'styles', 'zwiftbikes'].
- --ignore-list-overwrite: Overwrite the default ignore list with the provided one.

Functions:
- get_git_repo_url(): Retrieves the Git repository URL.
- should_ignore(path, ignore_list): Determines if a path should be ignored based on the ignore list.
- generate_file_list(directory, ignore_list): Generates a list of files in the specified directory, excluding ignored files.
- calculate_luminance(hex_color): Calculates the luminance of a hex color.
- is_dark_color(hex_color): Determines if a hex color is dark based on the luminance threshold.
- is_bright_color(hex_color): Determines if a hex color is bright based on the luminance threshold.
- is_readable_color(hex_color): Determines if a hex color is readable based on the luminance.
- get_random_color(color_range=None): Generates a random color within the specified range, avoiding excluded colors.
- should_exclude_color(color): Determines if a color should be excluded based on the exclusion settings.
- is_black_color(color): Determines if a color is considered black based on the threshold.
- generate_file_list_with_links(file_list, repo_url, color_source="random", color_range=None, color_list=None): Generates an HTML file list with links to each file.
- sort_files_by_extension(files): Sorts files by their extensions.
- save_file_list(file_list_html, output_file): Saves the generated HTML file list to the specified output file.
- split_into_chunks(file_list_html, chunk_size): Splits the HTML file list into chunks of a specified size.
- write_html_header(f): Writes the HTML header to the output file.
- write_lazyload_placeholders(f, file_list_chunks): Writes placeholders for lazy loading the file list chunks.
- write_lazyload_script(f, file_list_chunks): Writes the lazy loading script to the output file.

Main entry point:
- Parses command-line arguments, sets up logging, and generates the file list.
"""

import argparse
import logging
import math
import os
import random
import subprocess
import urllib.parse
from collections import defaultdict

# Anything set in the configuration section can be overridden by the command line arguments.
# The command line arguments will take precedence over the configuration settings.
# The configuration settings are used as defaults if the command line arguments are not provided.

# --- Configuration ---

# Fallback repository URL
# Specifies the fallback URL of the GitHub repository if the default URL cannot be determined by get_git_repo_url.
FALLBACK_REPO_URL = "https://github.com/author/repo"


# Function to get the Git repository URL using the Git command-line interface
# Returns the URL of the Git repository or the fallback URL if an error occurs
# The URL is converted to an HTTPS URL if it is an SSH URL
# The URL is stripped of the ".git" extension if present
# The URL is formatted for GitHub, GitLab, or Bitbucket
# Returns: str: The URL of the Git repository or the fallback URL
def get_git_repo_url():
    try:
        try:
            result = subprocess.run(  # Run the Git command to get the remote origin URL
          [
              "git",  # Git command
              "config",  # Git command to get the configuration
              "--get",  # Get the value of the configuration
              "remote.origin.url",  # Get the remote origin URL
          ],  # Get the remote origin URL
          capture_output=True,  # Capture the output of the command
          text=True,  # Return the output as text
          check=True,  # Raise an exception if the command fails
            )
            url = result.stdout.strip()  # Get the URL from the output and strip whitespace
        except subprocess.CalledProcessError as e:
            logging.error(f"\033[1;31mError running Git command: {e}\033[0m", exc_info=True)
            url = ""

        if not url:
            raise subprocess.CalledProcessError(1, "git config --get remote.origin.url")

        # Check if the URL ends with ".git" and remove it
        if url.endswith(".git"):  # Check if the URL ends with ".git"
            url = url[:-4]  # Remove the ".git" extension

        # Ensure the URL is an HTTPS URL by converting SSH URLs if necessary
        if url.startswith("git@github.com:"):  # Check if the URL is a GitHub SSH URL
            url = url.replace("git@github.com:", "https://github.com/")  # Convert the URL to HTTPS
        # Check if the URL is a GitLab SSH URL
        elif url.startswith("git@gitlab.com:"):
            url = url.replace("git@gitlab.com:", "https://gitlab.com/")  # Convert the URL to HTTPS
        elif url.startswith("git@bitbucket.org:"):  # Check if the URL is a Bitbucket SSH URL
            url = url.replace("git@bitbucket.org:", "https://bitbucket.org/")  # Convert the URL to HTTPS
        return url  # Return the formatted URL
    except subprocess.CalledProcessError as e:  # Handle errors from the Git command
        logging.error(
            f"\033[1;31mError getting Git repository URL: {e}\033[0m",
            exc_info=True,  # Log the error
        )
        return FALLBACK_REPO_URL  # Return the fallback URL if an error occurs
    except Exception as e:  # Handle any other exceptions
        logging.error(
            f"\033[1;31mUnexpected error: {e}\033[0m",
            exc_info=True,  # Log the error
        )
        return FALLBACK_REPO_URL  # Return the fallback URL if an error occurs


# --- Configuration ---
# Default GitHub repository URL
# Specifies the default URL of the GitHub repository.
DEFAULT_GIT_REPO_URL = get_git_repo_url()  # Get the Git repository URL

# Root directory
# Specifies the root directory of the repository to generate the file list for.
# Default value is the current directory.
ROOT_DIRECTORY = "."

# Ignore list
# Specifies a list of files and folders to ignore during the directory walk.
IGNORE_LIST = [".git", "node_modules", ".DS_Store", ".history", "styles", "zwiftbikes"]

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

# Chunk size
# Specifies the number of lines per chunk for lazy loading.
CHUNK_SIZE = 40

# Viewport sizes
# Specifies the viewport sizes for different devices.
# These values are used to determine the root margin for the IntersectionObserver.
# Default values are based on common device sizes. (unit is pixels)
# The large desktop viewport is everything greater than VIEWPORT_SMALL_DESKTOP, unless viewport sizes are set/determined.
VIEWPORT_MOBILE = 768
VIEWPORT_TABLET = 1024
VIEWPORT_SMALL_DESKTOP = 1440

# Root Margin
# Specifies the root margin for the IntersectionObserver.
# The root margin is a box that is added around the root element to increase or decrease the intersection area.
# The format is "top right bottom left".
# Default values are based on the viewport size.
ROOT_MARGIN_LARGE_DESKTOP = "0px 0px 400px 0px"
ROOT_MARGIN_SMALL_DESKTOP = "0px 0px 300px 0px"
ROOT_MARGIN_TABLET = "0px 0px 200px 0px"
ROOT_MARGIN_MOBILE = "0px 0px 100px 0px"


# File categories
# Specifies categories of files based on their extensions.
# Each category includes:
# - ext: The file extension.
# - name: The display name of the category.
# - files: An empty list that will be populated with files matching the extension.
FILE_CATEGORIES = [
    {"ext": ".user.css", "name": "Userstyles", "files": []},  # Userstyles category
    {"ext": ".user.js", "name": "Userscripts", "files": []},  # Userscripts category
    {"ext": ".css", "name": "CSS", "files": []},  # CSS category
    {"ext": ".js", "name": "JavaScript", "files": []},  # JavaScript category
    {"ext": ".yml", "name": "YAML", "files": []},  # YAML category
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
LOG_LEVEL_SETTING = "CRITICAL"
# --- End Configuration ---


def should_ignore(path, ignore_list):  # Find out which files and directories to ignore
    """
    Determines if a path should be ignored based on the ignore list.

    Args:
        path (str): The path to check.
        ignore_list (list): The list of files and folders to ignore.

    Returns:
        bool: True if the path should be ignored, False otherwise.
    """
    try:
        normalized_path = os.path.normpath(path)  # Normalize the path to remove trailing slashes
        for ignore_item in ignore_list:
            if ignore_item in normalized_path.split(os.sep):
                return True
        return False
    except ValueError as e:  # Handle errors
        logging.error(
            # Log the error
            f"\033[1;31mError in should_ignore function: {type(e).__name__}: {e}\033[0m"
        )
        return False  # Return False by default


def generate_file_list(directory, ignore_list):
    """
    Generate a list of files in a directory, excluding those that match the ignore list.

    Args:
      directory (str): The root directory to walk through.
      ignore_list (list): A list of patterns or file paths to ignore.

    Returns:
      list: A list of relative file paths that do not match the ignore list.

    Logs:
      Logs the number of files generated at the specified log level.
      Logs an error message if an OSError or ValueError occurs during file list generation.
    """
    file_list = set()  # Using a set to avoid duplicates
    try:  # Try to generate the file list
        # Walk through the directory
        for root, dirs, files in os.walk(directory):
            # Filter directories in-place to avoid walking into ignored directories
            dirs[:] = list(
                filter(
                    lambda d: not should_ignore(os.path.join(root, d), ignore_list),  # Filter out ignored directories
                    dirs,  # Directories to filter
                )
            )
            for file in files:  # Iterate over the files
                file_path = os.path.join(root, file)  # Get the full file path
                ignore_file = should_ignore(file_path, ignore_list)  # Check if the file should be ignored
                if not ignore_file:  # If the file should not be ignored
                    relative_path = os.path.relpath(file_path, directory)  # Get the relative file path
                    normalized_path = relative_path.replace(os.sep, '/')  # Normalize the path to use Unix-like separators
                    file_list.add(normalized_path)  # Add the normalized path to the list
        logging.log(
            getattr(logging, LOG_LEVEL_SETTING),
            # Log the number of files generated
            f"\033[1;32mGenerated file list with {len(file_list)} files.\033[0m",
        )
    except (OSError, ValueError) as e:  # Handle errors
        logging.error(
            # Log the error
            f"\033[1;31mError generating file list: {type(e).__name__}: {e}\033[0m"
        )
    return sorted(file_list, key=lambda x: (os.path.dirname(x), os.path.basename(x)))  # Return the sorted list of files


def calculate_luminance(hex_color):  # Calculate the luminance of a hex color
    """
    Calculate the luminance of a hex color.
    Args:
      hex_color (str): A string representing a hex color (e.g., "#RRGGBB").
    Returns:
      float: The calculated luminance value of the color. Returns 0 if an error occurs.
    Raises:
      ValueError: If the hex color string is not in the correct format.
    """
    try:  # Try to calculate the luminance
        r, g, b = [int(hex_color[i : i + 2], 16) for i in (1, 3, 5)]  # Convert the hex color to RGB values
        return 0.2126 * r + 0.7152 * g + 0.0722 * b  # Calculate the luminance
    except ValueError as e:  # Handle errors
        logging.error(
            # Log the error
            f"\033[1;31mError calculating luminance for color {hex_color}: {e}\033[0m"
        )
        return 0  # Return 0 by default


def is_dark_color(hex_color):  # Determine if a hex color is dark
    """
    Determines if a given hex color code represents a dark color.

    Args:
      hex_color (str): A string representing the hex color code (e.g., "#RRGGBB").

    Returns:
      bool: True if the color is considered dark, False otherwise.

    Raises:
      Exception: If there is an error in calculating the luminance.

    Note:
      This function relies on the `calculate_luminance` function and the
      `DARK_COLOR_LUMINANCE_THRESHOLD` constant to determine if the color is dark.
    """
    try:  # Try to determine if the color is dark
        luminance = calculate_luminance(hex_color)  # Calculate the luminance of the color
        return luminance < DARK_COLOR_LUMINANCE_THRESHOLD  # Return True if the luminance is below the threshold
    except Exception as e:  # Handle errors
        logging.error(f"\033[1;31mError in is_dark_color function: {e}\033[0m")  # Log the error
        return False  # Return False by default


def is_bright_color(hex_color):  # Determine if a hex color is bright
    """
    Determines if a given hex color is considered bright based on its luminance.

    Args:
      hex_color (str): The hex color code in the format '#RRGGBB'.

    Returns:
      bool: True if the color is bright, False otherwise.

    Raises:
      Exception: If there is an error in calculating the luminance.

    Logs:
      Error: Logs an error message if an exception occurs during luminance calculation.
    """
    try:  # Try to determine if the color is bright
        luminance = calculate_luminance(hex_color)  # Calculate the luminance of the color
        return luminance > BRIGHT_COLOR_LUMINANCE_THRESHOLD  # Return True if the luminance is above the threshold
    except Exception as e:  # Handle errors
        logging.error(f"\033[1;31mError in is_bright_color function: {e}\033[0m")  # Log the error
        return False  # Return False by default


def is_readable_color(hex_color):  # Determine if a hex color is readable
    """
    Determines if a given hex color is within a readable luminance range.

    Args:
      hex_color (str): The hex color code (e.g., '#FFFFFF' for white).

    Returns:
      bool: True if the luminance of the color is between 50 and 200, False otherwise.

    Raises:
      Exception: If there is an error in calculating the luminance, it logs the error and returns False.
    """
    try:  # Try to determine if the color is readable
        luminance = calculate_luminance(hex_color)  # Calculate the luminance of the color
        return 50 < luminance < 200  # Return True if the luminance is within the readable range
    except Exception as e:  # Handle errors
        logging.error(f"\033[1;31mError in is_readable_color function: {e}\033[0m")  # Log the error
        return False  # Return False by default


def get_random_color(color_range=None):  # Generate a random color
    """
    Generate a random color in hexadecimal format.

    If a color range is provided, the generated color will be within the specified range.
    The color range should be a tuple of two hexadecimal color strings (e.g., ("#000000", "#FFFFFF")).
    If the color range is invalid (i.e., the start color is greater than the end color), an error is logged, and a "random color" is returned.

    Args:
      color_range (tuple, optional): A tuple containing two hexadecimal color strings representing the range. Defaults to None.

    Returns:
      str: A hexadecimal color string.

    Logs:
      Error: If the color range is invalid or if a valid color could not be generated within the maximum attempts.
    """
    try:
        if color_range and any(  # Check if the color range is invalid
            int(color_range[0][i : i + 2], 16) > int(color_range[1][i : i + 2], 16) for i in range(1, 7, 2)  # Check if the start color is greater than the end color  # Iterate over the color range
        ):
            logging.error(
                # Log the error
                f"\033[1;31mInvalid color range: {color_range[0]} should be <= {color_range[1]}\033[0m"
            )
            logging.warning(
                # Log a warning if a random color is generated
                "\033[1;33mGenerated a random color due to error in color range.\033[0m"
            )
            # Return a random color if the color range is invalid
            return f"#{random.randint(0, 0xFFFFFF):06x}"
        for _ in range(MAX_ATTEMPTS):  # Try to generate a valid color within the maximum attempts
            if color_range:  # Check if a color range is specified
                r_min, g_min, b_min = [int(color_range[0][i : i + 2], 16) for i in (1, 3, 5)]  # Get the RGB values of the start color  # Convert the hex color to RGB values
                r_max, g_max, b_max = [  # Get the RGB values of the end color
                    int(color_range[1][i : i + 2], 16)  # Convert the hex color to RGB values
                    for i in (  # Iterate over the color range
                        1,
                        3,
                        5,
                    )  # Convert the hex color to RGB values  # Iterate over the color range
                ]  # Get the RGB values of the end color
                r = random.randint(r_min, r_max)  # Generate a random value for the red component
                g = random.randint(g_min, g_max)  # Generate a random value for the green component
                b = random.randint(b_min, b_max)  # Generate a random value for the blue component
                # Format the RGB values as a hex color
                color = f"#{r:02x}{g:02x}{b:02x}"
            else:  # If no color range is specified (full random range)
                # Generate a random color
                color = f"#{random.randint(0, 0xFFFFFF):06x}"
            # Check if the color should not be excluded
            if not should_exclude_color(color):
                return color  # Return the color if it is valid
        logging.error(
            # Log an error if a valid color could not be generated
            "\033[1;31mFailed to generate a valid color within max attempts.\033[0m"
        )
        logging.warning(
            # Log a warning if a random color is generated
            "\033[1;33mGenerated a random color due to error in color range.\033[0m"
        )
        # Return a random color if a valid color could not be generated
        return f"#{random.randint(0, 0xFFFFFF):06x}"
    except Exception as e:
        logging.error(f"\033[1;31mError generating random color: {e}\033[0m")
        return f"#{random.randint(0, 0xFFFFFF):06x}"


def should_exclude_color(color):  # Determine if a color should be excluded
    """
    Determines if a given color should be excluded based on various criteria.

    Args:
      color (str): The color to be evaluated.

    Returns:
      bool: True if the color should be excluded, False otherwise.

    The function checks the following conditions:
    - If EXCLUDE_DARK_COLORS is set to True and the color is dark.
    - If EXCLUDE_BRIGHT_COLORS is set to True and the color is bright.
    - If EXCLUDE_BLACKS is set to True and the color is black.
    - If ENSURE_READABLE_COLORS is set to True and the color is not readable.
    """
    try:
        # Check if the color should be excluded based on the exclusion settings
        if EXCLUDE_DARK_COLORS and is_dark_color(color):
            return True  # Exclude dark colors if the setting is enabled
        if EXCLUDE_BRIGHT_COLORS and is_bright_color(color):
            return True  # Exclude bright colors if the setting is enabled
        if EXCLUDE_BLACKS and is_black_color(color):
            return True  # Exclude black colors if the setting is enabled
        if ENSURE_READABLE_COLORS and not is_readable_color(color):
            return True  # Exclude colors that are not readable if the setting is enabled
        return False  # Do not exclude the color if none of the conditions are met
    except Exception as e:
        logging.error(f"\033[1;31mError in should_exclude_color function: {e}\033[0m")
        return False


def is_black_color(color):  # Determines if a given color is considered black based on a threshold.
    """
    Determines if a given color is considered black based on a threshold.

    Args:
            color (str): A string representing a color in hexadecimal format (e.g., '#000000').

    Returns:
            bool: True if the color is considered black, False otherwise.
    """
    try:
        # Convert the color from hex format to an integer value
        color_int_value = int(color[1:], 16)
        # Convert the threshold from hex format to an integer value
        threshold_value = int(EXCLUDE_BLACKS_THRESHOLD[1:], 16)
        # Compare the color value to the threshold value
        return color_int_value <= threshold_value
    except ValueError as e:
        logging.error(f"\033[1;31mError in is_black_color function: {e}\033[0m")
        return False


def generate_file_list_with_links(file_list, repo_url, color_source="random", color_range=None, color_list=None):
    """Generates an HTML list of files with links to a repository, categorized by file type and folder.

    Args:
      file_list (list): A list of file paths relative to the repository root.
      repo_url (str): The URL of the repository.
      color_source (str, optional): The source of the color for the links.
        Can be "random" to generate a random color, "list" to choose from a predefined list,
        or any other value to default to a random color with a warning. Defaults to "random".
      color_range (tuple, optional): A tuple specifying the range of the random color. Defaults to None.
      color_list (list, optional): A list of colors to choose from when color_source is "list".
        Defaults to DEFAULT_COLOR_LIST.

    Returns:
      str: An HTML string containing an unordered list of files, with links to the repository.
         The list is categorized by file type (e.g., CSS, JS) and folder.
         Returns an empty string if an error occurs during HTML generation.

    Raises:
      OSError: If there is an operating system error.
      ValueError: If there is a value error.
      KeyError: If there is a key error.
      Exception: If there is an error generating sorted HTML.

    Notes:
      - The function uses a default color list if `color_list` is not provided.
      - The function logs the number of HTML links generated and any errors encountered.
      - The function encodes the URL to handle special characters.
      - The function sorts files within each category and folder by extension.
      - The function uses global constants such as `FILE_CATEGORIES`, `DEFAULT_COLOR_LIST`, `REPO_ROOT_HEADER`, and `LOG_LEVEL`.
      - The function depends on helper functions `get_random_color` and `sort_files_by_extension`.
    """
    color_list = color_list or DEFAULT_COLOR_LIST  # Use the provided color list or fall back to the default color list if not provided
    file_list_html = defaultdict(list)  # Use defaultdict to group files by folder
    try:  # Try to generate the file list with links
        for file in file_list:  # Iterate over the file list
            file_url = f"{repo_url}/blob/main/{file.replace(os.sep, '/')}"  # Construct the file URL
            file_url = urllib.parse.quote(file_url, safe="/:")  # Encode the URL to handle special characters

            if color_source == "random":  # Check if the color source is random
                color = get_random_color(color_range)  # Generate a random color
            elif color_source == "list":  # Check if the color source is a list
                color = random.choice(color_list)  # Choose a random color from the list
            else:  # If the color source is invalid
                color = get_random_color()  # Generate a random color
                logging.warning(f"\033[1;33mGenerated a random color due to error in color source.\033[0m")  # Log a warning

            for category in FILE_CATEGORIES:  # Iterate over the file categories
                if file.endswith(category["ext"]):  # Check if the file ends with the category extension
                    category["files"].append(f'<li><a href="{file_url}" style="color: {color};">{file.replace(os.sep, "/")}</a></li>')  # Add the file to the category  # Create the HTML link
                    break  # Break out of the loop
            else:  # If the file does not belong to any category
                folder = os.path.dirname(file)  # Get the folder name
                file_list_html[folder].append(f'<li><a href="{file_url}" style="color: {color};">{file.replace(os.sep, "/")}</a></li>')  # Add the file to the folder  # Create the HTML link

        logging.log(  # Log the number of HTML links generated
            getattr(logging, LOG_LEVEL_SETTING),
            f"\033[1;32mGenerated HTML links for {len(file_list)} files.\033[0m",
        )
    except (OSError, ValueError, KeyError) as e:  # Handle errors
        logging.error(f"\033[1;31mError generating HTML links: {type(e).__name__}: {e}\033[0m")  # Log the error

    try:  # Try to generate the sorted HTML
        sorted_html = []  # Initialize a list to store the sorted HTML

        root_files = []  # Initialize a list to store the root files
        if "" in file_list_html:  # Check if there are files in the root directory
            root_files = file_list_html.pop("")  # Get the root files

        if root_files:  # Check if there are root files
            sorted_html.append(f"<li><h2>{REPO_ROOT_HEADER}</h2></li>")  # Add the root header
            sorted_html.extend(sorted(root_files, key=lambda x: os.path.splitext(x)[1]))  # Add the sorted root files

        for category in FILE_CATEGORIES:  # Iterate over the file categories
            if category["files"]:  # Check if the category has files
                sorted_html.append(f'<li><h2>{category["name"]}</h2></li>')  # Add the category header
                sorted_html.extend(sorted(category["files"]))  # Add the sorted category files

        for folder in sorted(file_list_html):  # Iterate over the folders
            sorted_html.append(f"<li><h2>{folder}</h2></li>")  # Add the folder header
            sorted_html.extend(sort_files_by_extension(file_list_html[folder]))  # Add the sorted files in the folder

        sorted_html.append("</ul>")  # Add the closing tag
        return "\n".join(sorted_html)  # Return the HTML
    except Exception as e:  # Handle errors
        logging.error(f"\033[1;31mError generating sorted HTML: {e}\033[0m")  # Log the error
        return ""  # Return an empty string


def sort_files_by_extension(files):  # Sort files by their extensions
    """Sorts a list of files by their extensions.

    Args:
      files (list): A list of file names.

    Returns:
      list: A list of file names sorted by their extensions.
          Returns the original list if an error occurs during sorting.
    """
    try:  # Try to sort the files by their extensions
        return sorted(files, key=lambda x: os.path.splitext(x)[1])  # Sort the files by their extensions
    except Exception as e:  # Handle errors
        logging.error(f"\033[1;31mError sorting files by extension: {e}\033[0m")  # Log the error
        return files  # Return the original list of files


def save_file_list(file_list_html, output_file):  # Save the file list to an output file
    """Saves the generated file list HTML content to an output file.

    The function processes the HTML content, splits it into chunks, and writes it to the specified output file.
    It includes HTML headers, placeholders for lazy loading, and a script to handle the lazy loading.

    Args:
      file_list_html (str): The HTML content representing the file list.
      output_file (str): The path to the output file where the HTML content will be saved.

    Raises:
      IOError: If there is an error writing to the output file.
      OSError: If there is an operating system-related error during file writing.
      Exception: If there is an error processing the file list.
    """
    try:
        file_list_html = "\n".join(line.replace("\\", "/") for line in file_list_html.splitlines())
        file_list_chunks = split_into_chunks(file_list_html, CHUNK_SIZE)
    except Exception as e:
        logging.error(f"\033[1;31mError processing file list: {e}\033[0m")
        return

    try:
        with open(output_file, "w", encoding="utf-8") as f:
            write_html_header(f)
            # Write placeholders for lazy loading the file list chunks
            write_lazyload_placeholders(f, file_list_chunks)
            write_lazyload_script(f, file_list_chunks)
        logging.log(
            getattr(logging, LOG_LEVEL_SETTING),
            f"\033[1;32mFile list saved to {output_file}\033[0m",
        )
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
    try:
        for line in file_list_html.splitlines():
            current_chunk.append(line)
            if len(current_chunk) >= chunk_size:
                file_list_chunks.append("\n".join(current_chunk))
                current_chunk = []
        if current_chunk:
            file_list_chunks.append("\n".join(current_chunk))
    except Exception as e:
        logging.error(f"\033[1;31mError splitting file list into chunks: {e}\033[0m")
        return []
    return file_list_chunks


def write_html_header(f):  # Write the HTML header to the file
    """Writes the HTML header to the specified file.

    Args:
            f: The file object to write to.

    Raises:
            Exception: If there is an error writing to the file.
    """
    try:
        f.write(f"<h1>{HEADER_TEXT}</h1>\n\n")  # Write the header text to the file
        f.write(f"<p>{INTRO_TEXT}</p>\n\n")  # Write the intro text to the file
    except Exception as e:
        logging.error(f"\033[1;31mError writing HTML header: {e}\033[0m")  # Log the error


def write_lazyload_placeholders(f, file_list_chunks):
    """Writes placeholders for lazy loading the file list chunks to the specified file.

    Args:
            f: The file object to write to.
            file_list_chunks (list): A list of HTML chunks, each containing a part of the file list.

    Raises:
            Exception: If there is an error writing to the file.
    """
    try:
        for i in range(len(file_list_chunks)):
            # Write a div with a class for lazy loading and a data attribute to identify the content
            f.write(f"""<div class="lazyload-placeholder" data-content="file-list-{i+1}" style="min-height: 400px;"></div>\n""")
    except Exception as e:
        # Log an error message if writing to the file fails
        logging.error(f"\033[1;31mError writing lazyload placeholders: {e}\033[0m")


def write_lazyload_script(f, file_list_chunks):
    """Writes the lazy loading script to the output file.

    Args:
            f: The file object to write to.
            file_list_chunks (list): A list of HTML chunks, each containing a part of the file list.

    Raises:
            Exception: If there is an error writing to the file.
    """
    try:
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
            f.write(f"                        case 'file-list-{i+1}':\n")
            f.write(f"                            file_list_html = `<ul>{file_list_chunks[i]}</ul>`;\n")
            f.write(f"                            break;\n")
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
            f.write(f"                case 'file-list-{i+1}':\n")
            f.write(f"                    file_list_html = `<ul>{file_list_chunks[i]}</ul>`;\n")
            f.write(f"                    break;\n")
        f.write(
            "            }\n"
            "            placeholder.innerHTML = file_list_html;\n"
            "        });\n"
            "    }\n"
            "});\n"
            "</script>\n"
        )
    except Exception as e:
        logging.error(f"\033[1;31mError writing lazyload script: {e}\033[0m")


if __name__ == "__main__":  # Main entry point of the script
    """
    Main entry point of the script.
    Parses command-line arguments, sets up logging, and generates the file list.

    Args:
        args (argparse.Namespace): The command-line arguments parsed by argparse.
    """
    parser = argparse.ArgumentParser(  # Create an argument parser
        # Set the description for the parser
        description="Generate a file list for a GitHub repository with HTML links."
    )
    parser.add_argument(  # Add an argument for the log level
        "--log-level",
        default=LOG_LEVEL_SETTING,  # Set the default log level
        choices=[  # Define the choices for log levels
            "DEBUG",
            "INFO",
            "WARNING",
            "ERROR",
            "CRITICAL",
        ],  # Define the choices for log levels
        # Set the help message
        help="\033[1;32mSet the logging level setting manually instead of pulling from environment\033[0m",
        type=str.upper,  # Automatically convert to uppercase
    )
    parser.add_argument(  # Add an argument for the directory
        "--directory",
        default=ROOT_DIRECTORY,  # Set the default directory
        metavar="DIRECTORY",  # Set the metavar for the argument
        # Set the help message
        help="\033[1;34mRoot directory of the repository to generate the file list for. Default is the current directory.\033[0m",
    )
    parser.add_argument(  # Add an argument for the repository URL
        "--repo-url",
        default=DEFAULT_GIT_REPO_URL,  # Set the default repository URL
        metavar="REPO_URL",  # Set the metavar for the argument
        # Set the help message
        help="\033[1;36mGitHub repository URL to use for generating file links. Default is determined by the Git configuration.\033[0m",
    )
    parser.add_argument(  # Add an argument for the fallback repository URL
        "--fallback-repo-url",
        default=FALLBACK_REPO_URL,  # Set the default fallback repository URL
        metavar="FALLBACK_REPO_URL",  # Set the metavar for the argument
        # Set the help message
        help="\033[1;35mFallback GitHub repository URL to use if the default URL cannot be determined.\033[0m",
    )
    parser.add_argument(  # Add an argument for the output file
        "--output-file",
        default=DEFAULT_OUTPUT_FILE,  # Set the default output file
        metavar="OUTPUT_FILE.html",  # Set the metavar for the argument
        # Set the help message
        help="\033[1;33mName of the output HTML file to save the generated file list. Default is 'file_list.html'.\033[0m",
    )
    parser.add_argument(  # Add an argument for the color source
        "--color-source",
        choices=["random", "list"],  # Define the choices for color sources
        default=DEFAULT_COLOR_SOURCE,  # Set the default color source
        # Set the help message
        help="\033[1;32mSource of colors for the file links. Choose 'random' for randomly generated colors or 'list' to use a predefined list of colors.\033[0m",
    )
    parser.add_argument(  # Add an argument for the color list
        "--color-list",
        nargs="+",  # Accept multiple values
        metavar="COLOR",  # Set the metavar for the argument
        default=DEFAULT_COLOR_LIST,  # Set the default color list
        # Set the help message
        help="\033[1;31mList of colors to use when the color source is set to 'list'. Provide colors in hex format (e.g., #FF0000).\033[0m",
    )
    parser.add_argument(  # Add an argument for the color range
        "--color-range",
        nargs=2,  # Accept two values
        metavar=("COLOR_MIN", "COLOR_MAX"),  # Set the metavar for the argument
        default=DEFAULT_COLOR_RANGE,  # Set the default color range
        # Set the help message
        help="\033[1;35mRange of colors (hex codes) for random color generation. Provide two hex codes representing the lower and upper bounds (e.g., --color-range #000000 #FFFFFF).\033[0m",
    )
    parser.add_argument(  # Add an argument to exclude dark colors
        "--exclude-dark-colors",
        action="store_true",  # Store True if the argument is provided
        default=EXCLUDE_DARK_COLORS,  # Set the default value
        # Set the help message
        help="\033[1;36mExclude dark colors from being used for file links. Use this option to avoid dark colors.\033[0m",
    )
    parser.add_argument(  # Add an argument to exclude bright colors
        "--exclude-bright-colors",
        action="store_true",  # Store True if the argument is provided
        default=EXCLUDE_BRIGHT_COLORS,  # Set the default value
        # Set the help message
        help="\033[1;33mExclude bright colors from being used for file links. Use this option to avoid bright colors.\033[0m",
    )
    parser.add_argument(  # Add an argument to exclude black colors
        "--exclude-blacks",
        action="store_true",  # Store True if the argument is provided
        default=EXCLUDE_BLACKS,  # Set the default value
        # Set the help message
        help="\033[1;32mExclude black colors below a certain threshold from being used for file links. Use this option to avoid very dark colors.\033[0m",
    )
    parser.add_argument(  # Add an argument for the maximum number of attempts
        "--max-attempts",
        type=int,  # Accept an integer value
        metavar="100",  # Set the metavar for the argument
        default=MAX_ATTEMPTS,  # Set the default value
        # Set the help message
        help="\033[1;34mMaximum number of attempts to generate a valid color. Default is 100.\033[0m",
    )
    parser.add_argument(  # Add an argument for the threshold for excluding black colors
        "--exclude-blacks-threshold",
        type=str,  # Accept a string value
        metavar="#222222",  # Set the metavar for the argument
        default=EXCLUDE_BLACKS_THRESHOLD,  # Set the default value
        # Set the help message
        help="\033[1;31mThreshold for excluding black colors. Any color below this threshold on the color chart will be excluded (e.g., #222222).\033[0m",
    )
    parser.add_argument(  # Add an argument to ensure readable colors
        "--ensure-readable-colors",
        action="store_true",  # Store True if the argument is provided
        default=ENSURE_READABLE_COLORS,  # Set the default value
        # Set the help message
        help="\033[1;34mEnsure that the generated colors are readable by maintaining a certain contrast ratio with a white background.\033[0m",
    )
    parser.add_argument(  # Add an argument for the repository root header
        "--repo-root-header",
        type=str,  # Accept a string value
        metavar=("Repo Root"),  # Set the metavar for the argument
        default=REPO_ROOT_HEADER,  # Set the default value
        # Set the help message
        help="\033[1;35mHeader text for files located in the root of the repository. Default is 'Repo Root'.\033[0m",
    )
    parser.add_argument(  # Add an argument for the header text
        "--header-text",
        type=str,  # Accept a string value
        metavar=("## File List"),  # Set the metavar for the argument
        default=HEADER_TEXT,  # Set the default value
        # Set the help message
        help="\033[1;36mHeader text for the file list displayed at the top of the generated HTML file. Default is '## File List'.\033[0m",
    )
    parser.add_argument(  # Add an argument for the introductory text
        "--intro-text",
        type=str,  # Accept a string value
        metavar=("# Here is a list of files included in this repository:"),  # Set the metavar for the argument
        default=INTRO_TEXT,  # Set the default value
        # Set the help message
        help="\033[1;33mIntroductory text for the file list displayed below the header in the generated HTML file. Default is '# Here is a list of files included in this repository:'.\033[0m",
    )
    parser.add_argument(  # Add an argument for the dark color luminance threshold
        "--dark-color-luminance-threshold",
        type=int,  # Accept an integer value
        metavar="128",  # Set the metavar for the argument
        default=DARK_COLOR_LUMINANCE_THRESHOLD,  # Set the default value
        # Set the help message
        help="\033[1;32mLuminance threshold for determining if a color is dark. Colors with luminance below this value will be considered dark. Default is 128.\033[0m",
    )
    parser.add_argument(  # Add an argument for the bright color luminance threshold
        "--bright-color-luminance-threshold",
        type=int,  # Accept an integer value
        metavar="200",  # Set the metavar for the argument
        default=BRIGHT_COLOR_LUMINANCE_THRESHOLD,  # Set the default value
        # Set the help message
        help="\033[1;31mLuminance threshold for determining if a color is bright. Colors with luminance above this value will be considered bright. Default is 200.\033[0m",
    )
    parser.add_argument(  # Add an argument for the chunk size
        "--chunk-size",
        type=int,  # Accept an integer value
        metavar="40",  # Set the metavar for the argument
        default=CHUNK_SIZE,  # Set the default value
        # Set the help message
        help="\033[1;34mNumber of lines per chunk for lazy loading the file list. Default is 40 lines per chunk.\033[0m",
    )
    parser.add_argument(  # Add an argument for the viewport size for mobile devices
        "--viewport-mobile",
        type=int,  # Accept an integer value
        metavar="768",  # Set the metavar for the argument
        default=VIEWPORT_MOBILE,  # Set the default value
        # Set the help message
        help="\033[1;34mViewport size for mobile devices in pixels. Default is 768.\033[0m",
    )
    parser.add_argument(  # Add an argument for the viewport size for tablets
        "--viewport-tablet",
        type=int,  # Accept an integer value
        metavar="1024",  # Set the metavar for the argument
        default=VIEWPORT_TABLET,  # Set the default value
        # Set the help message
        help="\033[1;34mViewport size for tablets in pixels. Default is 1024.\033[0m",
    )
    parser.add_argument(  # Add an argument for the viewport size for small desktops
        "--viewport-small-desktop",
        type=int,  # Accept an integer value
        metavar="1440",  # Set the metavar for the argument
        default=VIEWPORT_SMALL_DESKTOP,  # Set the default value
        # Set the help message
        help="\033[1;34mViewport size for small desktops in pixels. Default is 1440.\033[0m",
    )
    parser.add_argument(  # Add an argument for the root margin for the large desktop viewport
        "--root-margin-large-desktop",
        type=str,  # Accept a string value
        metavar="0px 0px 400px 0px",  # Set the metavar for the argument
        default=ROOT_MARGIN_LARGE_DESKTOP,  # Set the default value
        # Set the help message
        help="\033[1;34mRoot margin for the IntersectionObserver for large desktop viewport. Default is '0px 0px 400px 0px'.\033[0m",
    )
    parser.add_argument(  # Add an argument for the root margin for small desktops
        "--root-margin-small-desktop",
        type=str,  # Accept a string value
        metavar="0px 0px 300px 0px",  # Set the metavar for the argument
        default=ROOT_MARGIN_SMALL_DESKTOP,  # Set the default value
        # Set the help message
        help="\033[1;34mRoot margin for the IntersectionObserver for small desktops. Default is '0px 0px 300px 0px'.\033[0m",
    )
    parser.add_argument(  # Add an argument for the root margin for tablets
        "--root-margin-tablet",
        type=str,  # Accept a string value
        metavar="0px 0px 200px 0px",  # Set the metavar for the argument
        default=ROOT_MARGIN_TABLET,  # Set the default value
        # Set the help message
        help="\033[1;34mRoot margin for the IntersectionObserver for tablets. Default is '0px 0px 200px 0px'.\033[0m",
    )
    parser.add_argument(  # Add an argument for the root margin for mobile devices
        "--root-margin-mobile",
        type=str,  # Accept a string value
        metavar="0px 0px 100px 0px",  # Set the metavar for the argument
        default=ROOT_MARGIN_MOBILE,  # Set the default value
        # Set the help message
        help="\033[1;34mRoot margin for the IntersectionObserver for mobile devices. Default is '0px 0px 100px 0px'.\033[0m",
    )
    parser.add_argument(  # Add an argument for the file categories
        "--file-categories",
        nargs="+",  # Accept multiple values
        metavar=("EXT", "NAME"),  # Set the metavar for the argument
        default=None,  # Set the default value
        # Set the help message
        help="\033[1;32mList of file categories to include in the file list. Provide pairs of file extensions and category names (e.g., --file-categories .py Python .js JavaScript).\033[0m",
    )
    parser.add_argument(  # Add an argument to overwrite the default file categories
        "--overwrite-file-categories",  # Set the argument name
        action="store_true",  # Store True if the argument is provided
        # Set the help message
        help="\033[1;32mOverwrite the default file categories with the provided ones.\033[0m",
    )
    parser.add_argument(  # Add an argument for the ignore list
        "--ignore-list",
        nargs="+",  # Accept multiple values
        metavar="IGNORE_ITEM",  # Set the metavar for the argument
        default=None,  # Set the default value
        # Set the help message
        help="\033[1;32mList of files and folders to ignore during the directory walk. Provide file or folder names (e.g., --ignore-list .git node_modules).\033[0m",
    )
    parser.add_argument(  # Add an argument to overwrite the default ignore list
        "--overwrite-ignore-list",  # Set the argument name
        action="store_true",  # Store True if the argument is provided
        # Set the help message
        help="\033[1;32mOverwrite the default ignore list with the provided one.\033[0m",
    )

    args = parser.parse_args()  # Parse the command-line arguments

    if args.file_categories:  # Check if file categories are provided
        additional_categories = [  # Create a list of additional categories
            {
                "ext": args.file_categories[i],  # Set the file extension
                "name": args.file_categories[i + 1],  # Set the category name
                "files": [],  # Initialize an empty list for files
            }
            for i in range(0, len(args.file_categories), 2)  # Iterate over the file categories in pairs
        ]
        if args.overwrite_file_categories:  # Check if the overwrite flag is set
            FILE_CATEGORIES = additional_categories  # Overwrite the default file categories
        else:
            FILE_CATEGORIES.extend(additional_categories)  # Extend the default file categories with the additional ones

    if args.ignore_list:  # Check if ignore list is provided
        if args.overwrite_ignore_list:  # Check if the overwrite flag is set
            IGNORE_LIST = args.ignore_list  # Overwrite the default ignore list
        else:
            IGNORE_LIST.extend(args.ignore_list)  # Extend the default ignore list with the additional ones

    # Default repo_url to fallback_repo_url if not provided
    if not args.repo_url:  # Check if the repo_url argument is not provided
        args.repo_url = args.fallback_repo_url  # Set repo_url to fallback_repo_url if not provided

    if args.color_range:  # Check if the color_range argument is provided
        try:
            if not all(  # Validate each color in the color_range
                color.startswith("#")  # Check if the color starts with '#'
                # Check if the color length is 7 characters
                and len(color) == 7 and all(c in "0123456789abcdefABCDEF" for c in color[1:])  # Check if all characters are valid hex digits
                # Iterate over each color in the color_range
                for color in args.color_range
            ):
                raise ValueError("\033[1;31mInvalid color code(s). Color codes must be in hex format (#RRGGBB).\033[0m")  # Raise a ValueError if any color is invalid
        except ValueError as e:  # Handle the ValueError
            logging.error(e)  # Log the error
            exit(1)  # Exit the script with status code 1

    # Only override the default value if the argument is provided
    LOG_LEVEL_SETTING = args.log_level.upper()  # Set the log level
    ROOT_DIRECTORY = args.directory  # Set the root directory
    DEFAULT_GIT_REPO_URL = args.repo_url  # Set the default Git repository URL
    # Set the fallback Git repository URL
    FALLBACK_REPO_URL = args.fallback_repo_url
    DEFAULT_OUTPUT_FILE = args.output_file  # Set the default output file
    DEFAULT_COLOR_SOURCE = args.color_source  # Set the default color source
    DEFAULT_COLOR_RANGE = args.color_range  # Set the default color range
    EXCLUDE_DARK_COLORS = args.exclude_dark_colors  # Set the exclusion of dark colors
    EXCLUDE_BRIGHT_COLORS = args.exclude_bright_colors  # Set the exclusion of bright colors
    EXCLUDE_BLACKS = args.exclude_blacks  # Set the exclusion of black colors
    MAX_ATTEMPTS = args.max_attempts  # Set the maximum number of attempts to generate a valid color
    EXCLUDE_BLACKS_THRESHOLD = args.exclude_blacks_threshold  # Set the threshold for excluding black colors
    ENSURE_READABLE_COLORS = args.ensure_readable_colors  # Set the setting for ensuring readable colors
    REPO_ROOT_HEADER = args.repo_root_header  # Set the repository root header
    HEADER_TEXT = args.header_text  # Set the header text
    INTRO_TEXT = args.intro_text  # Set the introductory text
    DARK_COLOR_LUMINANCE_THRESHOLD = args.dark_color_luminance_threshold  # Set the dark color luminance threshold
    BRIGHT_COLOR_LUMINANCE_THRESHOLD = args.bright_color_luminance_threshold  # Set the bright color luminance threshold
    CHUNK_SIZE = args.chunk_size  # Set the chunk size for lazy loading
    # Set the viewport size for mobile devices
    VIEWPORT_MOBILE = args.viewport_mobile
    VIEWPORT_TABLET = args.viewport_tablet  # Set the viewport size for tablets
    VIEWPORT_SMALL_DESKTOP = args.viewport_small_desktop  # Set the viewport size for small desktops
    ROOT_MARGIN_LARGE_DESKTOP = args.root_margin_large_desktop  # Set the root margin for the large desktop viewport
    ROOT_MARGIN_SMALL_DESKTOP = args.root_margin_small_desktop  # Set the root margin for small desktops
    ROOT_MARGIN_TABLET = args.root_margin_tablet  # Set the root margin for tablets
    ROOT_MARGIN_MOBILE = args.root_margin_mobile  # Set the root margin for mobile devices

    # Set up logging
    LOG_LEVEL = (os.getenv("LOG_LEVEL") or LOG_LEVEL_SETTING).upper()  # Get the log level from the environment variable or use the default setting
    logging.basicConfig(
        level=getattr(logging, LOG_LEVEL_SETTING),  # Set the logging level
        # Set the logging format
        format="%(asctime)s - %(levelname)s - %(message)s",
    )

    # Log the values of all arguments
    logging.log(  # Log the log level
        getattr(logging, LOG_LEVEL),
        # Log the start of the script
        f"\033[1;32mStarting script with arguments:\033[0m {args}",
    )
    logging.info(f"\033[1;32mFILE_CATEGORIES is set to:\033[0m {FILE_CATEGORIES}")  # Log the file categories
    logging.info(f"\033[1;32mOVERWRITE_FILE_CATEGORIES is set to:\033[0m {args.overwrite_file_categories}")  # Log the overwrite file categories argument
    logging.info(f"\033[1;32mIGNORE_LIST is set to:\033[0m {IGNORE_LIST}")  # Log the ignore list
    logging.info(f"\033[1;32mOVERWRITE_IGNORE_LIST is set to:\033[0m {args.overwrite_ignore_list}")  # Log the overwrite ignore list argument
    logging.info(f"\033[1;94mLOG_LEVEL is set to:\033[0m {args.log_level}")  # Log the log level
    logging.info(
        # Log the repository root header
        f"\033[1;94mREPO_ROOT_HEADER is set to:\033[0m {args.repo_root_header}"
    )
    logging.info(f"\033[1;95mHEADER_TEXT is set to:\033[0m {args.header_text}")  # Log the header text
    logging.info(f"\033[1;32mDIRECTORY is set to:\033[0m {args.directory}")  # Log the directory
    logging.info(f"\033[1;33mREPO_URL is set to:\033[0m {args.repo_url}")  # Log the repository URL
    logging.info(
        # Log the fallback repository URL
        f"\033[1;34mFALLBACK_REPO_URL is set to:\033[0m {args.fallback_repo_url}"
    )
    logging.info(f"\033[1;35mCOLOR_SOURCE is set to:\033[0m {args.color_source}")  # Log the color source
    logging.info(f"\033[1;36mCOLOR_RANGE is set to:\033[0m {args.color_range}")  # Log the color range
    logging.info(
        # Log the exclusion of dark colors
        f"\033[1;93mEXCLUDE_DARK_COLORS is set to:\033[0m {args.exclude_dark_colors}"
    )
    logging.info(
        # Log the dark color luminance threshold
        f"\033[1;93mDARK_COLOR_LUMINANCE_THRESHOLD is set to:\033[0m {args.dark_color_luminance_threshold}"
    )
    logging.info(
        # Log the exclusion of bright colors
        f"\033[1;91mEXCLUDE_BRIGHT_COLORS is set to:\033[0m {args.exclude_bright_colors}"
    )
    logging.info(
        # Log the bright color luminance threshold
        f"\033[1;31mBRIGHT_COLOR_LUMINANCE_THRESHOLD is set to:\033[0m {args.bright_color_luminance_threshold}"
    )
    logging.info(f"\033[1;35mEXCLUDE_BLACKS is set to:\033[0m {args.exclude_blacks}")  # Log the exclusion of black colors
    logging.info(
        # Log the threshold for excluding black colors
        f"\033[1;35mEXCLUDE_BLACKS_THRESHOLD is set to:\033[0m {args.exclude_blacks_threshold}"
    )
    logging.info(f"\033[1;35mMAX_ATTEMPTS is set to:\033[0m {args.max_attempts}")  # Log the maximum number of attempts to generate a valid color
    logging.info(
        # Log the setting for ensuring readable colors
        f"\033[1;93mENSURE_READABLE_COLORS is set to:\033[0m {args.ensure_readable_colors}"
    )
    logging.info(f"\033[1;34mCHUNK_SIZE is set to:\033[0m {args.chunk_size}")  # Log the chunk size for lazy loading
    logging.info(f"\033[1;34mVIEWPORT_MOBILE is set to:\033[0m {args.viewport_mobile}")  # Log the viewport size for mobile devices
    logging.info(f"\033[1;34mVIEWPORT_TABLET is set to:\033[0m {args.viewport_tablet}")  # Log the viewport size for tablets
    logging.info(
        # Log the viewport size for small desktops
        f"\033[1;34mVIEWPORT_SMALL_DESKTOP is set to:\033[0m {args.viewport_small_desktop}"
    )
    logging.info(
        # Log the root margin for the large desktop viewport
        f"\033[1;34mROOT_MARGIN_LARGE_DESKTOP is set to:\033[0m {args.root_margin_large_desktop}"
    )
    logging.info(
        # Log the root margin for small desktops
        f"\033[1;34mROOT_MARGIN_SMALL_DESKTOP is set to:\033[0m {args.root_margin_small_desktop}"
    )
    logging.info(
        # Log the root margin for tablets
        f"\033[1;34mROOT_MARGIN_TABLET is set to:\033[0m {args.root_margin_tablet}"
    )
    logging.info(
        # Log the root margin for mobile devices
        f"\033[1;34mROOT_MARGIN_MOBILE is set to:\033[0m {args.root_margin_mobile}"
    )

    file_list = generate_file_list(args.directory, IGNORE_LIST)  # Generate the file list
    file_list_html = generate_file_list_with_links(  # Generate the file list with links
        file_list,  # The file list
        (args.repo_url if args.repo_url else args.fallback_repo_url),  # The repository URL
        args.color_source,  # The color source for the links
        args.color_range,  # The color range for random colors
        args.color_list,  # The list of colors
    )

    save_file_list(file_list_html, args.output_file)  # Save the file list to an HTML file

    logging.log(getattr(logging, LOG_LEVEL_SETTING), "\033[1;32mScript finished.\033[0m")  # Log the completion of the script
