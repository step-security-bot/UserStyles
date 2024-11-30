// ==UserScript==
// @name         Strava Text Auto-Selector
// @namespace    https://github.com/Nick2bad4u/UserScripts
// @version      1.0.1
// @description  Automatically selects text in specific Strava elements and displays a notification near the cursor
// @author       Nick2bad4u
// @license      UnLicense
// @homepageURL  https://github.com/Nick2bad4u/UserScripts
// @grant        none
// @include      *://*.strava.com/activities/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=strava.com
// @downloadURL
// @updateURL
// ==/UserScript==

(function () {
  'use strict';

  // Wait for the page to fully load
  window.addEventListener('load', function () {
    // Define the elements to target
    const selectors = [
      '.content',
      '#heading > div > div.row.no-margins.activity-summary-container > div.spans8.activity-summary.mt-md.mb-md > div.details-container > div > h1',
    ];

    selectors.forEach((selector) => {
      const targetElement = document.querySelector(selector);
      if (targetElement) {
        // Add a click event listener to the target element
        targetElement.addEventListener('click', function (event) {
          // Select all text inside the element
          const range = document.createRange();
          range.selectNodeContents(targetElement);

          const selection = window.getSelection();
          selection.removeAllRanges();
          selection.addRange(range);

          // Copy the selected text to the clipboard
          const copiedText = selection.toString();
          navigator.clipboard
            .writeText(copiedText)
            .then(() => {
              // Display a notification near the cursor
              showNotification(event.clientX, event.clientY, 'Text Copied!');
            })
            .catch(() => {
              showNotification(event.clientX, event.clientY, 'Failed to Copy!');
            });
        });
      }
    });

    // Function to display a notification near the cursor
    function showNotification(x, y, message) {
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

      document.body.appendChild(notification);

      // Remove the notification after 2 seconds
      setTimeout(() => {
        notification.remove();
      }, 2000);
    }
  });
})();
