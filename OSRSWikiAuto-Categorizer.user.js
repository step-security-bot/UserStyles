// ==UserScript==
// @name         OSRS Wiki Auto-Categorizer with UI, Adaptive Speed, and Global Scope
// @namespace    http://tampermonkey.net/
// @version      1.6
// @description  Adds listed pages to a category upon request with UI, CSRF token, adaptive speed, and global compatibility
// @author       Nick2bad4u
// @match        https://oldschool.runescape.wiki/*
// @grant        GM_xmlhttpRequest
// @icon         https://www.google.com/s2/favicons?sz=64&domain=oldschool.runescape.wiki
// @updateURL    https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/OSRSWikiAuto-Categorizer.user.js
// @downloadURL  https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/OSRSWikiAuto-Categorizer.user.js
// @license      UnLicense
// ==/UserScript==

(function() {
    'use strict';

    // Global variables
    const versionNumber = '1.6';
    let categoryName = '';        // Stores the requested category name
    let pageLinks = [];           // Stores all applicable page links on the current page
    let selectedLinks = [];       // Stores selected page links for categorization
    let currentIndex = 0;         // Tracks current page being processed
    let csrfToken = '';           // Stores CSRF token for authenticated actions
    let isCancelled = false;      // Flag to cancel ongoing categorization
    let isRunning = false;        // Indicates if categorization is in progress
    let requestInterval = 500;    // Initial interval between API requests, adapts based on rate limiting
    const maxInterval = 5000;     // Maximum interval to wait after rate limiting occurs
    const excludedPrefixes = ["Template:", "File:", "Category:", "Module:"]; // Pages to exclude

    // Add UI elements to start, cancel, and display progress of the categorization process
    function addButtonAndProgressBar() {
        const container = document.createElement('div');
        container.id = 'categorize-ui';
        container.style = `position: fixed; bottom: 20px; right: 20px; z-index: 1000;
            background-color: #2b2b2b; color: #ffffff; padding: 12px;
            border: 1px solid #595959; border-radius: 8px; font-family: Arial, sans-serif; width: 250px;`;

        // Start Button
        const startButton = document.createElement('button');
        startButton.textContent = 'Start Categorizing';
        startButton.style = `background-color: #4caf50; color: #fff; border: none;
            padding: 6px 12px; border-radius: 5px; cursor: pointer;`;
        startButton.onclick = promptCategoryName;
        container.appendChild(startButton);

        // Cancel Button
        const cancelButton = document.createElement('button');
        cancelButton.textContent = 'Cancel';
        cancelButton.style = `background-color: #d9534f; color: #fff; border: none;
            padding: 6px 12px; border-radius: 5px; cursor: pointer; margin-left: 10px;`;
        cancelButton.onclick = cancelCategorization;
        container.appendChild(cancelButton);

        // Progress Bar and Status Text
        const progressBarContainer = document.createElement('div');
        progressBarContainer.style = `width: 100%; margin-top: 10px; background-color: #3d3d3d;
            height: 20px; border-radius: 5px; position: relative;`;
        progressBarContainer.id = 'progress-bar-container';

        const progressBar = document.createElement('div');
        progressBar.style = `width: 0%; height: 100%; background-color: #4caf50; border-radius: 5px;`;
        progressBar.id = 'progress-bar';
        progressBarContainer.appendChild(progressBar);

        const progressText = document.createElement('span');
        progressText.id = 'progress-text';
        progressText.style = `position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%);
            font-size: 12px; color: #ffffff; white-space: nowrap; overflow: visible; text-align: center;`;
        progressBarContainer.appendChild(progressText);

        container.appendChild(progressBarContainer);
        document.body.appendChild(container);
    }

    // Prompt user for category name and initiate the link fetching process
    function promptCategoryName() {
        categoryName = prompt("Enter the category name you'd like to add:");
        if (!categoryName) {
            alert("Category name is required.");
            return;
        }

        getPageLinks();
        if (pageLinks.length === 0) {
            alert("No pages found to categorize.");
            return;
        }

        displayPageSelectionPopup();
    }

    // Retrieve applicable page links on the current page, filtering out excluded prefixes
    function getPageLinks() {
        pageLinks = Array.from(document.querySelectorAll('#mw-content-text a'))
            .map(link => link.getAttribute('href'))
            .filter(href => href && href.startsWith('/w/'))
            .map(href => decodeURIComponent(href.replace('/w/', '')))
            .filter(page => !excludedPrefixes.some(prefix => page.startsWith(prefix)));
    }

    // Display popup for selecting pages to categorize
    function displayPageSelectionPopup() {
        const popup = document.createElement('div');
        popup.style = `position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);
            z-index: 1001; background-color: #2b2b2b; padding: 15px; color: white;
            border-radius: 8px; max-height: 80vh; overflow-y: auto; border: 1px solid #595959;`;

        const title = document.createElement('h3');
        title.textContent = 'Select Pages to Categorize';
        title.style = `margin: 0 0 10px; font-family: Arial, sans-serif;`;
        popup.appendChild(title);

        const listContainer = document.createElement('div');
        listContainer.style = `max-height: 300px; overflow-y: auto;`;
        pageLinks.forEach(link => {
            const listItem = document.createElement('div');
            const checkbox = document.createElement('input');
            checkbox.type = 'checkbox';
            checkbox.checked = true;
            checkbox.value = link;
            listItem.appendChild(checkbox);
            listItem.appendChild(document.createTextNode(` ${link}`));
            listContainer.appendChild(listItem);
        });
        popup.appendChild(listContainer);

        const buttonContainer = document.createElement('div');
        buttonContainer.style = `margin-top: 10px; display: flex; justify-content: space-between;`;

        const confirmButton = document.createElement('button');
        confirmButton.textContent = 'Confirm Selection';
        confirmButton.style = `padding: 5px 10px; background-color: #4caf50;
            border: none; color: white; cursor: pointer; border-radius: 5px;`;
        confirmButton.onclick = () => {
            selectedLinks = Array.from(listContainer.querySelectorAll('input:checked')).map(input => input.value);
            document.body.removeChild(popup);
            if (selectedLinks.length > 0) {
                startCategorization();
            } else {
                alert("No pages selected.");
            }
        };

        const cancelPopupButton = document.createElement('button');
        cancelPopupButton.textContent = 'Cancel';
        cancelPopupButton.style = `padding: 5px 10px; background-color: #d9534f;
            border: none; color: white; cursor: pointer; border-radius: 5px;`;
        cancelPopupButton.onclick = () => {
            document.body.removeChild(popup);
        };

        buttonContainer.appendChild(confirmButton);
        buttonContainer.appendChild(cancelPopupButton);
        popup.appendChild(buttonContainer);

        document.body.appendChild(popup);
    }

    // Start categorization process and fetch CSRF token for authorized API calls
    function startCategorization() {
        isCancelled = false;
        isRunning = true;
        currentIndex = 0;
        document.getElementById('progress-bar-container').style.display = 'block';
        console.log("Starting categorization with CSRF token fetch.");
        fetchCsrfToken(() => processNextPage());
    }

    // Process each page one at a time, updating progress bar and adjusting speed for rate limits
    function processNextPage() {
        if (isCancelled || currentIndex >= selectedLinks.length) {
            isRunning = false;
            alert(isCancelled ? "Categorization cancelled." : "Categorization complete!");
            resetUI();
            return;
        }

        const pageTitle = selectedLinks[currentIndex];
        console.log(`Processing page: ${pageTitle}`);
        updateProgressBar(`Processing: ${pageTitle}`);
        addCategoryToPage(pageTitle, () => {
            currentIndex++;
            updateProgressBar(`Processed: ${pageTitle}`);
            setTimeout(processNextPage, requestInterval);
        });
    }

    // Fetch CSRF token needed for API authorization
    function fetchCsrfToken(callback) {
        GM_xmlhttpRequest({
            method: "GET",
            url: "https://oldschool.runescape.wiki/api.php?action=query&meta=tokens&type=csrf&format=json",
            onload: response => {
                try {
                    const data = JSON.parse(response.responseText);
                    csrfToken = data.query.tokens.csrftoken;
                    console.log(`CSRF token fetched: ${csrfToken}`);
                    callback();
                } catch (error) {
                    console.error("Error fetching CSRF token:", error);
                    alert("Failed to fetch CSRF token. Check console for details.");
                }
            }
        });
    }

    // Add selected category to a specified page
    function addCategoryToPage(pageTitle, callback) {
        GM_xmlhttpRequest({
            method: "POST",
            url: "https://oldschool.runescape.wiki/api.php",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            data: `action=edit&format=json&title=${encodeURIComponent(pageTitle)}&appendtext=[[Category:${categoryName}]]&token=${encodeURIComponent(csrfToken)}`,
            onload: response => {
                const responseData = JSON.parse(response.responseText);
                if (responseData.edit && responseData.edit.result === "Success") {
                    console.log(`Successfully categorized: ${pageTitle}`);
                    callback();
                } else if (responseData.error && responseData.error.code === "ratelimited") {
                    console.warn(`Rate limit hit. Slowing down request interval.`);
                    requestInterval = Math.min(requestInterval + 500, maxInterval);
                    setTimeout(callback, requestInterval);
                } else {
                    console.error(`Error categorizing ${pageTitle}:`, responseData);
                    callback();
                }
            }
        });
    }

    // Update progress bar display
    function updateProgressBar(text) {
        const progress = (currentIndex / selectedLinks.length) * 100;
        document.getElementById('progress-bar').style.width = `${progress}%`;
        document.getElementById('progress-text').textContent = text;
    }

    // Cancel ongoing categorization and reset UI elements
    function cancelCategorization() {
        if (isRunning) {
            isCancelled = true;
        } else {
            alert("No categorization process is currently running.");
        }
    }

    // Reset UI elements after process completion or cancellation
    function resetUI() {
        document.getElementById('progress-bar').style.width = '0%';
        document.getElementById('progress-text').textContent = '';
        document.getElementById('progress-bar-container').style.display = 'none';
    }

    // Initialize the UI
    addButtonAndProgressBar();
})();
