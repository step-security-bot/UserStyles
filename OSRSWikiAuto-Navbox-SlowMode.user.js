// ==UserScript==
// @name         OSRS Wiki Auto-Navbox with UI, Adaptive Speed, Duplicate Checker (Slow Version)
// @namespace    https://github.com/Nick2bad4u/UserStyles
// @version      4.8
// @description  Adds listed pages to a Navbox upon request with UI, CSRF token, adaptive speed, duplicate checker, and highlighted links option.
// @author       Nick2bad4u
// @match        https://oldschool.runescape.wiki/*
// @match        https://runescape.wiki/*
// @match        https://*.runescape.wiki/*
// @match        https://api.runescape.wiki/*
// @match        https://classic.runescape.wiki/*
// @match        *://*.runescape.wiki/*
// @grant        GM_xmlhttpRequest
// @icon         https://www.google.com/s2/favicons?sz=64&domain=oldschool.runescape.wiki
// @license      UnLicense
// @downloadURL  https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/OSRSWikiAuto-Navbox-SlowMode.user.js
// @updateURL    https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/OSRSWikiAuto-Navbox-SlowMode.user.js
// ==/UserScript==

(function() {
    'use strict';
    const versionNumber = '4.8';
    let navboxName = '';
    let pageLinks = [];
    let selectedLinks = [];
    let currentIndex = 0;
    let csrfToken = '';
    let isCancelled = false;
    let isRunning = false;
    let requestInterval = 10000;
    const maxInterval = 20000;
    const excludedPrefixes = ["Template:", "File:", "Navbox:", "Module:", "RuneScape:", "Update:", "Exchange:", "RuneScape:", "User:", "Help:"];
    let actionLog = []; // Track actions for summary
    let existingNavboxes = []; // Stores existing navboxes

    function addButtonAndProgressBar() {
        console.log("Adding button and progress bar to the UI.");
        const container = document.createElement('div');
        container.id = 'Navbox-ui';
        container.style = `position: fixed; bottom: 20px; right: 20px; z-index: 1000;
            background-color: #2b2b2b; color: #ffffff; padding: 12px;
            border: 1px solid #595959; border-radius: 8px; font-family: Arial, sans-serif; width: 250px;`;

        const startButton = document.createElement('button');
        startButton.textContent = 'Start Categorizing';
        startButton.style = `background-color: #4caf50; color: #fff; border: none;
            padding: 6px 12px; border-radius: 5px; cursor: pointer;`;
        startButton.onclick = promptnavboxName;
        container.appendChild(startButton);

        const cancelButton = document.createElement('button');
        cancelButton.textContent = 'Cancel';
        cancelButton.style = `background-color: #d9534f; color: #fff; border: none;
            padding: 6px 12px; border-radius: 5px; cursor: pointer; margin-left: 10px;`;
        cancelButton.onclick = cancelNavbox;
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

    function promptnavboxName() {
        navboxName = prompt("Enter the Navbox name you'd like to add:");
        console.log("Navbox name entered:", navboxName);
        if (!navboxName) {
            alert("Navbox name is required.");
            return;
        }

        fetchExistingNavboxes(navboxName, () => {
            getPageLinks();
            if (pageLinks.length === 0) {
                alert("No pages found to Navbox.");
                console.log("No pages found after filtering.");
                return;
            }
            displayPageSelectionPopup();
        });
    }

    // Function to fetch all existing navboxes
    function fetchExistingNavboxes(navboxName, callback) {
        const apiUrl = `https://oldschool.runescape.wiki/api.php?action=query&list=allpages&apprefix=Navbox:${navboxName}&apnamespace=10&format=json`;
        GM_xmlhttpRequest({
            method: 'GET',
            url: apiUrl,
            onload(response) {
                const responseJson = JSON.parse(response.responseText);
                existingNavboxes = responseJson.query.allpages.map(page => page.title);
                console.log("Existing navboxes fetched:", existingNavboxes);
                callback();
            }
        });
    }

    // Function to check for highlighted text
    function getHighlightedText() {
        const selection = window.getSelection();
        if (selection.rangeCount > 0) {
            const container = document.createElement('div');
            for (let i = 0; i < selection.rangeCount; i++) {
                container.appendChild(selection.getRangeAt(i).cloneContents());
            }
            return container.innerHTML;
        }
        return '';
    }

    // Modify getPageLinks to consider highlighted text
    function getPageLinks() {
        let contextElement = document.querySelector('#mw-content-text');
        const highlightedText = getHighlightedText();

        if (highlightedText) {
            const tempContainer = document.createElement('div');
            tempContainer.innerHTML = highlightedText;
            contextElement = tempContainer;
        }

        pageLinks = Array.from(new Set(
            Array.from(contextElement.querySelectorAll('a'))
            .map(link => link.getAttribute('href'))
            .filter(href => href && href.startsWith('/w/'))
            .map(href => decodeURIComponent(href.replace('/w/', '')))
            .filter(page =>
                    !excludedPrefixes.some(prefix => page.startsWith(prefix)) &&
                    !page.includes('?') &&
                    !page.includes('/') &&
                    !page.includes('#')
                   )
        ));

        console.log("Filtered unique page links:", pageLinks);
    }

    function displayPageSelectionPopup() {
        // Display page selection code (same as previous)
    }

    function startNavbox() {
        console.log("Starting Navbox process.");
        isCancelled = false;
        isRunning = true;
        currentIndex = 0;
        document.getElementById('progress-bar-container').style.display = 'block';
        fetchCsrfToken(() => processNextPage());
    }

    function processNextPage() {
        if (isCancelled || currentIndex >= selectedLinks.length) {
            console.log("Navbox ended. Reason:", isCancelled ? "Cancelled" : "Completed");
            isRunning = false;
            if (!isCancelled) {
                displayCompletionSummary();
            }
            resetUI();
            return;
        }

        const pageTitle = selectedLinks[currentIndex];
        updateProgressBar(`Processing: ${pageTitle}`);
        console.log(`Processing page: ${pageTitle}`);
        addNavboxToPage(pageTitle, () => {
            currentIndex++;
            updateProgressBar(`Processed: ${pageTitle}`);
            setTimeout(processNextPage, requestInterval);
        });
    }

    function addNavboxToPage(pageTitle, callback) {
        const categories = [];

        function fetchCategories(clcontinue) {
            const apiUrl = `https://oldschool.runescape.wiki/api.php?action=query&prop=categories|revisions&titles=${encodeURIComponent(pageTitle)}&rvprop=content&format=json${clcontinue ? `&clcontinue=${clcontinue}` : ''}`;
            GM_xmlhttpRequest({
                method: 'GET',
                url: apiUrl,
                onload(response) {
                    const responseJson = JSON.parse(response.responseText);
                    const pageId = Object.keys(responseJson.query.pages)[0];
                    const page = responseJson.query.pages[pageId];

                    if (page.categories) {
                        categories.push(...page.categories.map(cat => cat.title));
                    }

                    if (responseJson.continue && responseJson.continue.clcontinue) {
                        fetchCategories(responseJson.continue.clcontinue);
                    } else {
                        if (categories.length === 0) {
                            console.log(`Skipped: '${pageTitle}' has no existing categories.`);
                            actionLog.push(`Skipped: '${pageTitle}' has no existing categories.`);
                            callback();
                            return;
                        }

                        const standardizedNavboxName = `Navbox:${navboxName}`;
                        const alreadyNavboxd = categories.includes(standardizedNavboxName) || existingNavboxes.includes(standardizedNavboxName);

                        if (alreadyNavboxd) {
                            console.log(`Page '${pageTitle}' is already in the Navbox.`);
                            actionLog.push(`Skipped: '${pageTitle}' already in '${navboxName}'`);
                            callback();
                        } else {
                            // Add navbox to page
                        }
                    }
                }
            });
        }
        fetchCategories();
    }

    function fetchCsrfToken(callback) {
        const apiUrl = 'https://oldschool.runescape.wiki/api.php?action=query&meta=tokens&type=csrf&format=json';
        GM_xmlhttpRequest({
            method: 'GET',
            url: apiUrl,
            onload(response) {
                const responseJson = JSON.parse(response.responseText);
                csrfToken = responseJson.query.tokens.csrftoken;
                console.log("CSRF token obtained.");
                callback();
            }
        });
    }

    function cancelNavbox() {
        isCancelled = true;
    }

    function displayCompletionSummary() {
        const summary = `Operation completed! Summary:\n${actionLog.join('\n')}`;
        alert(summary);
        actionLog = [];
    }

    function updateProgressBar(text) {
        const progress = ((currentIndex + 1) / selectedLinks.length) * 100;
        const progressBar = document.getElementById('progress-bar');
        const progressText = document.getElementById('progress-text');
        progressBar.style.width = `${progress}%`;
        progressText.textContent = `${text} (${currentIndex + 1}/${selectedLinks.length})`;
    }

    function resetUI() {
        document.getElementById('progress-bar-container').style.display = 'none';
        document.getElementById('progress-bar').style.width = '0%';
        document.getElementById('progress-text').textContent = '';
    }

    addButtonAndProgressBar();
})();
