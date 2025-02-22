import unittest
from unittest.mock import patch
import os
import subprocess
from collections import defaultdict
import logging
import argparse
import shutil

import urllib.parse

# Assuming your script is named generate_file_list.py
from generate_file_list import (
	get_git_repo_url,
	should_ignore,
	generate_file_list,
	calculate_luminance,
	is_dark_color,
	is_bright_color,
	is_readable_color,
	get_random_color,
	should_exclude_color,
	is_black_color,
	generate_file_list_with_links,
	sort_files_by_extension,
	split_into_chunks,
)

class TestGenerateFileList(unittest.TestCase):

	def test_should_ignore(self):
		ignore_list = ['.git', 'node_modules']
		self.assertTrue(should_ignore('.git/config', ignore_list))
		self.assertTrue(should_ignore('path/to/node_modules/file.js', ignore_list))
		self.assertFalse(should_ignore('path/to/file.js', ignore_list))

	def test_generate_file_list(self):
		# Create a dummy directory structure for testing
		os.makedirs('test_dir', exist_ok=True)
		with open('test_dir/test_file.txt', 'w') as f:
			f.write('test content')
		os.makedirs('test_dir/.git', exist_ok=True)
		with open('test_dir/.git/config', 'w') as f:
			f.write('test git config')

		ignore_list = ['.git']
		file_list = generate_file_list('test_dir', ignore_list)
		self.assertIn('test_file.txt', [os.path.basename(f) for f in file_list])
		self.assertNotIn('.git/config', [os.path.basename(f) for f in file_list])

		# Clean up the dummy directory
		shutil.rmtree('test_dir')

	def test_calculate_luminance(self):
		self.assertEqual(calculate_luminance("#FFFFFF"), 255.0)
		self.assertEqual(calculate_luminance("#000000"), 0.0)
		self.assertAlmostEqual(calculate_luminance("#808080"), 128.0, places=1)

	def test_is_dark_color(self):
		# Assuming DARK_COLOR_LUMINANCE_THRESHOLD = 128
		self.assertTrue(is_dark_color("#000000"))
		self.assertFalse(is_dark_color("#FFFFFF"))
		self.assertTrue(is_dark_color("#808080"))

	def test_is_bright_color(self):
		# Assuming BRIGHT_COLOR_LUMINANCE_THRESHOLD = 200
		self.assertFalse(is_bright_color("#000000"))
		self.assertTrue(is_bright_color("#FFFFFF"))
		self.assertFalse(is_bright_color("#808080"))

	def test_is_readable_color(self):
		self.assertTrue(is_readable_color("#808080"))
		self.assertFalse(is_readable_color("#FFFFFF"))
		self.assertFalse(is_readable_color("#000000"))

	@patch('generate_file_list.random.randint')
	def test_get_random_color(self, mock_randint):
		mock_randint.return_value = 0x123456
		self.assertEqual(get_random_color(), "#123456")

	def test_should_exclude_color(self):
		# This test requires setting EXCLUDE_DARK_COLORS, EXCLUDE_BRIGHT_COLORS, EXCLUDE_BLACKS, ENSURE_READABLE_COLORS
		# and mocking is_dark_color, is_bright_color, is_black_color, is_readable_color if you want to test all branches
		# Here's a basic example assuming all EXCLUDE flags are False and ENSURE_READABLE_COLORS is True
		with patch('generate_file_list.is_readable_color', return_value=False):
			self.assertTrue(should_exclude_color("#FFFFFF"))  # Because it's not readable

		with patch('generate_file_list.is_readable_color', return_value=True):
			self.assertFalse(should_exclude_color("#808080")) # Because it's readable

	def test_is_black_color(self):
		# Assuming EXCLUDE_BLACKS_THRESHOLD = "#222222"
		self.assertTrue(is_black_color("#000000"))
		self.assertFalse(is_black_color("#FFFFFF"))
		self.assertTrue(is_black_color("#222222"))
		self.assertFalse(is_black_color("#232323"))

	def test_generate_file_list_with_links(self):
		file_list = ['test_file.txt', 'path/to/another_file.txt']
		repo_url = 'https://github.com/test/repo'
		html = generate_file_list_with_links(file_list, repo_url)
		self.assertIn('<a href="https://github.com/test/repo/blob/main/test_file.txt"', html)
		self.assertIn('<a href="https://github.com/test/repo/blob/main/path/to/another_file.txt"', html)

	def test_sort_files_by_extension(self):
		files = ['file.js', 'file.css', 'file.html']
		sorted_files = sort_files_by_extension(files)
		self.assertEqual(sorted_files, ['file.css', 'file.html', 'file.js'])

	def test_split_into_chunks(self):
		file_list_html = "line1\nline2\nline3\nline4\nline5"
		chunks = split_into_chunks(file_list_html, 2)
		self.assertEqual(len(chunks), 3)
		self.assertEqual(chunks[0], "line1\nline2")
		self.assertEqual(chunks[1], "line3\nline4")
		self.assertEqual(chunks[2], "line5")

	@patch('generate_file_list.subprocess.run')
	def test_get_git_repo_url(self, mock_run):
		# Mock successful git command
		mock_run.return_value.stdout = "https://github.com/test/repo.git"
		mock_run.return_value.returncode = 0
		self.assertEqual(get_git_repo_url(), "https://github.com/test/repo")

		# Mock failed git command
		mock_run.side_effect = subprocess.CalledProcessError(1, 'git')
		self.assertEqual(get_git_repo_url(), "https://github.com/author/repo")

if __name__ == '__main__':
	unittest.main()
