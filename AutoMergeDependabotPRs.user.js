// ==UserScript==
// @name         Auto Merge Dependabot PRs
// @namespace    https://github.com/Nick2bad4u/UserStyles
// @version      1.3
// @description  Automatically clicks the merge button on Dependabot PRs and "Done" button on the notification bar
// @author       Nick2bad4u
// @match        https://github.com/*/*/pull/*
// @grant        none
// @icon         https://www.google.com/s2/favicons?sz=64&domain=github.com
// @license      UnLicense
// ==/UserScript==

(function () {
  "use strict";

  let lastCheck = 0;
  const CHECK_INTERVAL = 1000;
  let observer;

  function checkAndMerge() {
    const now = Date.now();
    if (now - lastCheck < CHECK_INTERVAL) return;
    lastCheck = now;

    console.log("checkAndMerge function called");

    const authorElement = document.querySelector(".author");
    if (
      authorElement &&
      /dependabot(\[bot\])?|Nick2bad4u/.test(authorElement.textContent.trim())
    ) {
      setTimeout(() => {
        const mergeButton = document.querySelector(".btn.btn-sm");
        if (mergeButton && !mergeButton.disabled) {
          console.log("Merge button is enabled, clicking it");
          mergeButton.click();
          if (observer) observer.disconnect();
          observeDoneButton();
        } else {
          console.log("Merge button is disabled or not found");
        }
      }, 500);
    } else {
      console.log("PR is not created by dependabot");
    }
  }

  function observeDoneButton() {
    console.log("Observing for Done button...");
    const notificationBar = document.querySelector(".js-flash-container"); // Adjust as necessary

    if (!notificationBar) {
      console.log("Notification bar not found");
      return;
    }

    const doneButtonObserver = new MutationObserver(() => {
      const doneButton = document.querySelector(
        'button[aria-label="Done"].btn.btn-sm',
      );
      if (doneButton) {
        console.log("Done button found, clicking it");
        doneButton.click();
        doneButtonObserver.disconnect(); // Stop observing after clicking
      }
    });

    doneButtonObserver.observe(notificationBar, {
      childList: true,
      subtree: true,
    });
  }

  globalThis.addEventListener(
    "load",
    function () {
      console.log("Page loaded");

      const targetNode = document.querySelector(".gh-header-meta");
      if (!targetNode) {
        console.log("Target node for observation not found");
        return;
      }

      observer = new MutationObserver(() => {
        console.log("Relevant DOM mutation detected");
        checkAndMerge();
      });

      observer.observe(targetNode, {
        childList: true,
        subtree: true,
      });
      checkAndMerge();
    },
    false,
  );
})();
