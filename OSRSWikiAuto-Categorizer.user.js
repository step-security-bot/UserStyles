// ==UserScript==
// @name         OSRS Wiki Auto-Categorizer with UI, Adaptive Speed, and Global Scope
// @namespace    http://tampermonkey.net/
// @version      1.3
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
    const versionNumber = '1.3';
    let categoryName = '';
    let pageLinks = [];
    let selectedLinks = [];
    let currentIndex = 0;
    let csrfToken = '';
    let isCancelled = false;
    let isRunning = false;
    let requestInterval = 500;
    const maxInterval = 5000;
    const excludedPrefixes = ["Template:", "File:", "Category:", "Module:"];

    function addButtonAndProgressBar() {
        const container = document.createElement('div');
        container.id = 'categorize-ui';
        container.style = `position: fixed; bottom: 20px; right: 20px; z-index: 1000;
            background-color: #2b2b2b; color: #ffffff; padding: 12px;
            border: 1px solid #595959; border-radius: 8px; font-family: Arial, sans-serif; width: 250px;`;

        const startButton = document.createElement('button');
        startButton.textContent = 'Start Categorizing';
        startButton.style = `background-color: #4caf50; color: #fff; border: none;
            padding: 6px 12px; border-radius: 5px; cursor: pointer;`;
        startButton.onclick = promptCategoryName;
        container.appendChild(startButton);

        const cancelButton = document.createElement('button');
        cancelButton.textContent = 'Cancel';
        cancelButton.style = `background-color: #d9534f; color: #fff; border: none;
            padding: 6px 12px; border-radius: 5px; cursor: pointer; margin-left: 10px;`;
        cancelButton.onclick = cancelCategorization;
        container.appendChild(cancelButton);

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

    function getPageLinks() {
        pageLinks = Array.from(document.querySelectorAll('#mw-content-text a'))
            .map(link => link.getAttribute('href'))
            .filter(href => href && href.startsWith('/w/'))
            .map(href => decodeURIComponent(href.replace('/w/', '')))
            .filter(page => !excludedPrefixes.some(prefix => page.startsWith(prefix)));
    }

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

    function startCategorization() {
        isCancelled = false;
        isRunning = true;
        currentIndex = 0;
        document.getElementById('progress-bar-container').style.display = 'block';
        fetchCsrfToken(() => processNextPage());
    }

    function processNextPage() {
        if (isCancelled || currentIndex >= selectedLinks.length) {
            isRunning = false;
            alert(isCancelled ? "Categorization cancelled." : "Categorization complete!");
            resetUI();
            return;
        }

        const pageTitle = selectedLinks[currentIndex];
        updateProgressBar(`Processing: ${pageTitle}`);
        addCategoryToPage(pageTitle, () => {
            currentIndex++;
            updateProgressBar(`Processed: ${pageTitle}`);
            setTimeout(processNextPage, requestInterval);
        });
    }

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
                    const editUrl = `https://oldschool.runescape.wiki/api.php?action=edit&title=${encodeURIComponent(pageTitle)}&appendtext=[[Category:${categoryName}]]&format=json`;

                    GM_xmlhttpRequest({
                        method: 'POST',
                        url: editUrl,
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'Api-User-Agent': `OSRSWikiAutoCategorizer/${versionNumber} (SubLife)`
                        },
                        data: `token=${encodeURIComponent(csrfToken)}`,
                        onload: function() {
                            requestInterval = Math.max(500, requestInterval - 500);
                            callback();
                        },
                        onerror: function() {
                            requestInterval = Math.min(maxInterval, requestInterval + 500);
                            callback();
                        }
                    });
                } else {
                    callback();
                }
            }
        });
    }

    function updateProgressBar(status) {
        const progressBar = document.getElementById('progress-bar');
        const progressText = document.getElementById('progress-text');
        const progressPercent = (currentIndex / selectedLinks.length) * 100;

        progressBar.style.width = `${progressPercent}%`;
        progressText.textContent = status;
    }

    function fetchCsrfToken(callback) {
        const apiUrl = `https://oldschool.runescape.wiki/api.php?action=query&meta=tokens&type=csrf&format=json`;

        GM_xmlhttpRequest({
            method: 'GET',
            url: apiUrl,
            onload: function(response) {
                const data = JSON.parse(response.responseText);
                csrfToken = data.query.tokens.csrftoken;
                callback();
            }
        });
    }

    function cancelCategorization() {
        isCancelled = true;
        isRunning = false;
    }

    function resetUI() {
        const progressBar = document.getElementById('progress-bar');
        const progressText = document.getElementById('progress-text');
        progressBar.style.width = '0%';
        progressText.textContent = '';
    }

    addButtonAndProgressBar();
})();

