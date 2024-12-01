// ==UserScript==
// @name         Strava Text Auto-Selector
// @namespace    https://github.com/Nick2bad4u/UserScripts
// @version      1.0.5
// @description  Automatically selects text in specific Strava elements and displays a notification near the cursor. Also allows right-click to copy text.
// @author       Nick2bad4u
// @license      UnLicense
// @homepageURL  https://github.com/Nick2bad4u/UserScripts
// @grant        none
// @include      *://*.strava.com/activities/*
// @include      *://*.strava.com/athlete/training
// @icon         https://www.google.com/s2/favicons?sz=64&domain=strava.com
// @downloadURL https://update.greasyfork.org/scripts/519370/Strava%20Text%20Auto-Selector.user.js
// @updateURL https://update.greasyfork.org/scripts/519370/Strava%20Text%20Auto-Selector.meta.js
// ==/UserScript==

(function() {
    'use strict';

    // Log when the script starts
    console.log('Strava Text Auto-Selector script loaded.');

    // Wait for the page to fully load
    window.addEventListener('load', function() {
        console.log('Page fully loaded, initializing script.');

        // Define the elements to target
        const selectors = [
            '#search-results > tbody > tr:nth-child(n) > td.view-col.col-title > a',
            '.content',
            '#heading > div > div.row.no-margins.activity-summary-container > div.spans8.activity-summary.mt-md.mb-md > div.details-container > div > h1'
        ];
        console.log('Selectors defined:', selectors);

        // Iterate through each selector
        selectors.forEach(selector => {
            console.log(`Processing selector: ${selector}`);

            // Query elements matching the selector
            const elements = document.querySelectorAll(selector);
            console.log(`Found ${elements.length} elements for selector: ${selector}`);

            // Iterate through the elements
            elements.forEach(targetElement => {
                console.log('Adding right-click event listener to element:', targetElement);

                // Add right-click (contextmenu) event listener
                targetElement.addEventListener('contextmenu', function(event) {
                    console.log('Right-click detected on element:', targetElement);

                    // Prevent the default right-click menu
                    event.preventDefault();
                    console.log('Default right-click menu prevented.');

                    // Select all text inside the element
                    const range = document.createRange();
                    range.selectNodeContents(targetElement);
                    console.log('Text range selected:', targetElement.textContent);

                    // Get the window selection
                    const selection = window.getSelection();
                    selection.removeAllRanges();
                    selection.addRange(range);
                    console.log('Text added to selection.');

                    // Copy the selected text to the clipboard
                    const copiedText = selection.toString();
                    console.log('Text copied to clipboard:', copiedText);

                    navigator.clipboard.writeText(copiedText).then(() => {
                        console.log('Clipboard write successful.');
                        // Display a notification near the cursor
                        showNotification(event.clientX, event.clientY, 'Text Copied!');
                    }).catch(() => {
                        console.log('Clipboard write failed.');
                        showNotification(event.clientX, event.clientY, 'Failed to Copy!');
                    });
                });
            });
        });

        // Function to display a notification near the cursor
        function showNotification(x, y, message) {
            console.log('Displaying notification:', message);

            // Create the notification element
            const notification = document.createElement('div');
            notification.textContent = message;
            notification.style.position = 'absolute';
            notification.style.left = `${x + 10}px`;
            notification.style.top = `${y + 10}px`;
            notification.style.background = 'rgba(0, 0, 0, 0.8)';
            notification.style.color = 'white';
            notification.style.padding = '5px 10px';
            notification.style.borderRadius = '5px';
            notification.style.fontSize = '12px';
            notification.style.zIndex = '1000';
            notification.style.pointerEvents = 'none';

            // Append the notification to the document body
            document.body.appendChild(notification);
            console.log('Notification added to DOM.');

            // Remove the notification after 2 seconds
            setTimeout(() => {
                notification.remove();
                console.log('Notification removed from DOM.');
            }, 2000);
        }
    });
})();

