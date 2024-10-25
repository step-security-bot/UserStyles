// ==UserScript==
// @name         OSRS Wiki Auto-Categorizer with UI, Adaptive Speed, and Global Scope
// @namespace    http://tampermonkey.net/
// @version      0.9
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

    let categoryName = '';
    let pageLinks = [];
    let currentIndex = 0;
    let csrfToken = '';
    let isCancelled = false;
    let requestInterval = 500; // Start with a fast interval of 500ms
    const maxInterval = 5000; // Maximum interval of 5 seconds for rate-limited adjustments
    const excludedPrefixes = ["Template:", "File:", "Category:", "Module:"];

    // Add UI button, progress bar, and cancel button to the page
    function addButtonAndProgressBar() {
        const container = document.createElement('div');
        container.style.position = 'fixed';
        container.style.bottom = '20px';
        container.style.right = '20px';
        container.style.zIndex = '1000';
        container.style.backgroundColor = '#2b2b2b';
        container.style.color = '#ffffff';
        container.style.padding = '12px';
        container.style.border = '1px solid #595959';
        container.style.borderRadius = '8px';
        container.style.fontFamily = 'Arial, sans-serif';
        // Fixed width for better text fitting
        container.style.width = '250px';
        container.id = 'categorize-ui';

        const startButton = document.createElement('button');
        startButton.textContent = 'Start Categorizing';
        startButton.style.backgroundColor = '#4caf50';
        startButton.style.color = '#fff';
        startButton.style.border = 'none';
        startButton.style.padding = '6px 12px';
        startButton.style.borderRadius = '5px';
        startButton.style.cursor = 'pointer';
        startButton.onclick = startCategorization;
        container.appendChild(startButton);

        const cancelButton = document.createElement('button');
        cancelButton.textContent = 'Cancel';
        cancelButton.style.backgroundColor = '#d9534f';
        cancelButton.style.color = '#fff';
        cancelButton.style.border = 'none';
        cancelButton.style.padding = '6px 12px';
        cancelButton.style.borderRadius = '5px';
        cancelButton.style.cursor = 'pointer';
        cancelButton.style.marginLeft = '10px';
        cancelButton.onclick = cancelCategorization;
        container.appendChild(cancelButton);

        const progressBarContainer = document.createElement('div');
        progressBarContainer.style.width = '100%';
        progressBarContainer.style.marginTop = '10px';
        progressBarContainer.style.backgroundColor = '#3d3d3d';
        progressBarContainer.style.height = '20px';
        progressBarContainer.style.borderRadius = '5px';
        progressBarContainer.id = 'progress-bar-container';
        progressBarContainer.style.position = 'relative';

        const progressBar = document.createElement('div');
        progressBar.style.width = '0%';
        progressBar.style.height = '100%';
        progressBar.style.backgroundColor = '#4caf50';
        progressBar.style.borderRadius = '5px';
        progressBar.id = 'progress-bar';
        progressBarContainer.appendChild(progressBar);

        const progressText = document.createElement('span');
        progressText.id = 'progress-text';
        progressText.style.position = 'absolute';
        progressText.style.left = '50%';
        progressText.style.top = '50%';
        progressText.style.transform = 'translate(-50%, -50%)';
        progressText.style.fontSize = '12px';
        progressText.style.color = '#ffffff';
        progressText.style.whiteSpace = 'nowrap';
        progressText.style.overflow = 'visible';
        progressText.style.textAlign = 'center';
        progressBarContainer.appendChild(progressText);

        container.appendChild(progressBarContainer);
        document.body.appendChild(container);
    }

    // Fetch CSRF token
    function fetchCsrfToken(callback) {
        const tokenUrl = `https://oldschool.runescape.wiki/api.php?action=query&meta=tokens&type=csrf&format=json`;

        GM_xmlhttpRequest({
            method: 'GET',
            url: tokenUrl,
            onload: function(response) {
                const data = JSON.parse(response.responseText);
                csrfToken = data.query.tokens.csrftoken;
                callback();
            },
            onerror: function() {
                alert('Failed to retrieve CSRF token');
            }
        });
    }

    // Parse links from the infobox, filtering out excluded prefixes
    function getPageLinks() {
        pageLinks = Array.from(document.querySelectorAll('#mw-content-text a'))
            .map(link => link.getAttribute('href'))
            .filter(href => href && href.startsWith('/w/'))
            .map(href => decodeURIComponent(href.replace('/w/', '')))
            .filter(page => !excludedPrefixes.some(prefix => page.startsWith(prefix)));
    }

    // Prompt for category and start processing
    function startCategorization() {
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

        isCancelled = false;
        currentIndex = 0;
        document.getElementById('progress-bar-container').style.display = 'block';
        fetchCsrfToken(() => processNextPage());
    }

    // Process each page with an adaptive delay to avoid rate limits
    function processNextPage() {
        if (isCancelled || currentIndex >= pageLinks.length) {
            if (isCancelled) alert("Categorization cancelled.");
            else alert("Categorization complete!");
            resetUI();
            return;
        }

        const pageTitle = pageLinks[currentIndex];
        updateProgressBar(`Processing: ${pageTitle}`);
        addCategoryToPage(pageTitle, () => {
            currentIndex++;
            updateProgressBar(`Processed: ${pageTitle}`);
            setTimeout(processNextPage, requestInterval); // Use adaptive request interval
        });
    }

    // Add a category to a page via the MediaWiki API with CSRF token
    function addCategoryToPage(pageTitle, callback) {
        const apiUrl = `https://oldschool.runescape.wiki/api.php?action=query&prop=categories&titles=${encodeURIComponent(pageTitle)}&format=json`;

        GM_xmlhttpRequest({
            method: 'GET',
            url: apiUrl,
            onload: function(response) {
                const data = JSON.parse(response.responseText);
                const pageId = Object.keys(data.query.pages)[0];
                const categories = data.query.pages[pageId].categories;

                if (!categories || !categories.some(cat => cat.title === `Category:${categoryName}`)) {
                    // Edit page to add category
                    const editUrl = `https://oldschool.runescape.wiki/api.php?action=edit&title=${encodeURIComponent(pageTitle)}&appendtext=[[Category:${categoryName}]]&format=json`;

                    GM_xmlhttpRequest({
                        method: 'POST',
                        url: editUrl,
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'Api-User-Agent': 'OSRSWikiAutoCategorizer/0.9 (SubLife)'
                        },
                        data: `token=${encodeURIComponent(csrfToken)}`,
                        onload: function(editResponse) {
                            console.log(`Category added to ${pageTitle}`);
                            requestInterval = Math.max(500, requestInterval - 500); // Decrease interval if successful
                            callback();
                        },
                        onerror: function() {
                            console.error(`Failed to add category to ${pageTitle}`);
                            requestInterval = Math.min(maxInterval, requestInterval + 500); // Increase interval if error
                            callback();
                        }
                    });
                } else {
                    console.log(`${pageTitle} already has the category`);
                    callback();
                }
            }
        });
    }

    // Update the progress bar with status and completion percentage
    function updateProgressBar(status) {
        const progressBar = document.getElementById('progress-bar');
        const progressText = document.getElementById('progress-text');
        const progressPercent = ((currentIndex + 1) / pageLinks.length) * 100;
        progressBar.style.width = `${progressPercent}%`;
        progressText.textContent = `${status} (${Math.round(progressPercent)}%)`;
    }

    // Cancel the categorization process
    function cancelCategorization() {
        isCancelled = true;
    }

    // Reset the UI to initial state after completion or cancellation
    function resetUI() {
        document.getElementById('progress-bar').style.width = '0%';
        document.getElementById('progress-text').textContent = '';
        document.getElementById('progress-bar-container').style.display = 'none';
        currentIndex = 0;
    }

    // Add the UI button and progress bar on page load
    addButtonAndProgressBar();
})();
