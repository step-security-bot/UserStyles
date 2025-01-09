// ==UserScript==
// @name         Hide Chinese Userstyles on Userstyles.World
// @namespace    typpi.online
// @version      1.3
// @description  Hide userstyles containing Chinese characters on userstyles.world
// @author       Nick2bad4u
// @license      UnLicense
// @match        https://userstyles.world/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=userstyles.world
// @grant        none
// @homepageURL  https://userstyles.github.typpi.online
// @downloadURL  https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/HideChineseUserstyles.user.js
// @updateURL    https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/HideChineseUserstyles.user.js
// ==/UserScript==
(function () {
	'use strict';

	// Function to check if a string contains Chinese characters
	function containsChineseCharacters(text) {
		return /[\u4E00-\u9FFF]/.test(text);
	}

	// Find all card elements on the page
	document
		.querySelectorAll('.card')
		.forEach((card) => {
			// Get the text content from relevant child elements
			const title =
				card.querySelector('.name')
					?.textContent || ''; // Get the title of the userstyle
			const description =
				card.querySelector('.card-body')
					?.textContent || ''; // Get the description of the userstyle
			const ariaLabel =
				card
					.querySelector('.card-header.thumbnail')
					?.getAttribute('aria-label') || ''; // Get the aria-label which may contain a description

			// Log the content being checked
			console.log(
				`Checking card: Title="${title}", Description="${description}", Aria-Label="${ariaLabel}"`,
			);

			// Check if any of these contain Chinese characters
			if (
				containsChineseCharacters(title) ||
				containsChineseCharacters(description) ||
				containsChineseCharacters(ariaLabel)
			) {
				// Hide the card if Chinese characters are found
				card.style.display = 'none';
				console.log(
					`Hiding card: Title="${title}", Description="${description}", Aria-Label="${ariaLabel}"`,
				);
			}
		});
})();
