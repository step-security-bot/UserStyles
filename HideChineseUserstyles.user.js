// ==UserScript==
// @name         Hide Chinese Userstyles on userstyles.world
// @namespace    typpi.online
// @version      1.0
// @description  Hide user styles containing Chinese characters on userstyles.world
// @author       You
// @match        https://userstyles.world/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=userstyles.world
// @grant        none
// ==/UserScript==
(function() {
    'use strict';

    // Function to check if a string contains Chinese characters
    function containsChineseCharacters(text) {
        return /[\u4E00-\u9FFF]/.test(text);
    }

    // Find all card elements
    document.querySelectorAll('.card').forEach(card => {
        // Get the text content from relevant child elements
        const title = card.querySelector('.name')?.textContent || '';
        const description = card.querySelector('.card-body')?.textContent || '';
        const ariaLabel = card.querySelector('.card-header.thumbnail')?.getAttribute('aria-label') || '';

        // Check if any of these contain Chinese characters
        if (containsChineseCharacters(title) || containsChineseCharacters(description) || containsChineseCharacters(ariaLabel)) {
            // Hide the card
            card.style.display = 'none';
        }
    });
})();
