// ==UserScript==
// @name         Old Reddit with New Reddit Profile Pictures - Universal Version
// @namespace    https://github.com/Nick2bad4u/UserStyles
// @version      3.6
// @description  Injects new Reddit profile pictures into Old Reddit and Reddit-Stream.com next to the username. Caches in localstorage.
// @author       Nick2bad4u
// @match        https://*.reddit.com/*
// @match        https://www.*.reddit.com/*
// @match        https://reddit-stream.com/*
// @connect      reddit.com
// @updateURL    https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/OldRedditNewProfilePictures-UniversalVersion.user.js
// @downloadURL  https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/OldRedditNewProfilePictures-UniversalVersion.user.js
// @license      Unlicense
// @icon         https://www.google.com/s2/favicons?sz=64&domain=reddit.com
// @run-at       document-start
// ==/UserScript==

(function () {
  "use strict";
  console.log("Script loaded");

  let profilePictureCache = JSON.parse(
    localStorage.getItem("profilePictureCache") || "{}"
  );
  let cacheTimestamps = JSON.parse(
    localStorage.getItem("cacheTimestamps") || "{}"
  );
  const CACHE_DURATION = 7 * 24 * 60 * 60 * 1000; // 7 days in milliseconds
  const MAX_CACHE_SIZE = 25000; // Maximum number of cache entries
  const REQUEST_DELAY = 100; // Delay between requests in milliseconds
  const LONG_DELAY = 5000; // Long delay after every 100 requests

  function saveCache() {
    localStorage.setItem(
      "profilePictureCache",
      JSON.stringify(profilePictureCache)
    );
    localStorage.setItem("cacheTimestamps", JSON.stringify(cacheTimestamps));
  }

  function flushOldCache() {
    console.log("Flushing old cache");
    const now = Date.now();
    for (const username in cacheTimestamps) {
      if (now - cacheTimestamps[username] > CACHE_DURATION) {
        console.log(`Deleting cache for ${username}`);
        delete profilePictureCache[username];
        delete cacheTimestamps[username];
      }
    }
    saveCache();
    console.log("Old cache entries flushed");
  }

  function limitCacheSize() {
    const cacheEntries = Object.keys(profilePictureCache);
    if (cacheEntries.length > MAX_CACHE_SIZE) {
      console.log("Cache size exceeded, removing oldest entries");
      const sortedEntries = cacheEntries.sort(
        (a, b) => cacheTimestamps[a] - cacheTimestamps[b]
      );
      const entriesToRemove = sortedEntries.slice(
        0,
        cacheEntries.length - MAX_CACHE_SIZE
      );
      entriesToRemove.forEach((username) => {
        delete profilePictureCache[username];
        delete cacheTimestamps[username];
      });
      saveCache();
      console.log("Cache size limited");
    }
  }

  function delay(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  async function fetchProfilePictures(usernames) {
    console.log("Fetching profile pictures");
    const uncachedUsernames = usernames.filter(
      (username) =>
        !profilePictureCache[username] &&
        username !== "[deleted]" &&
        username !== "[removed]"
    );
    if (uncachedUsernames.length === 0) {
      console.log("All usernames are cached");
      return usernames.map((username) => profilePictureCache[username]);
    }

    console.log(
      `Fetching profile pictures for: ${uncachedUsernames.join(", ")}`
    );

    let fetchCount = 0;
    for (const username of uncachedUsernames) {
      if (fetchCount > 0 && fetchCount % 100 === 0) {
        console.log(`Long delay after ${fetchCount} requests`);
        await delay(LONG_DELAY); // Long delay after every 100 requests
      } else {
        await delay(REQUEST_DELAY); // Regular delay between requests
      }
      fetchCount++;

      try {
        const response = await fetch(
          `https://www.reddit.com/user/${username}/about.json`
        );
        if (!response.ok) {
          console.error(
            `Error fetching profile picture for ${username}: ${response.statusText}`
          );
          continue;
        }
        const data = await response.json();
        if (data.data && data.data.icon_img) {
          const profilePictureUrl = data.data.icon_img.split("?")[0];
          profilePictureCache[username] = profilePictureUrl;
          cacheTimestamps[username] = Date.now();
          saveCache();
          console.log(`Fetched profile picture: ${username}`);
        } else {
          console.warn(`No profile picture found for: ${username}`);
        }
      } catch (error) {
        console.error(
          `Error fetching profile picture for ${username}:`,
          error
        );
      }
    }

    limitCacheSize();
    return usernames.map((username) => profilePictureCache[username]);
  }

  async function injectProfilePictures(comments) {
    console.log(`Comments found: ${comments.length}`);
    const usernames = Array.from(comments)
      .map((comment) => comment.textContent.trim())
      .filter(
        (username) => username !== "[deleted]" && username !== "[removed]"
      );
    const profilePictureUrls = await fetchProfilePictures(usernames);

    comments.forEach((comment, index) => {
      const username = usernames[index];
      const profilePictureUrl = profilePictureUrls[index];
      if (
        profilePictureUrl &&
        !comment.previousElementSibling?.classList.contains("profile-picture")
      ) {
        console.log(`Injecting profile picture: ${username}`);
        const img = document.createElement("img");
        img.src = profilePictureUrl;
        img.classList.add("profile-picture");
        img.onerror = () => {
          img.style.display = "none";
        };
        img.addEventListener("click", () => {
          window.open(profilePictureUrl, "_blank");
        });
        comment.insertAdjacentElement("beforebegin", img);

        const enlargedImg = document.createElement("img");
        enlargedImg.src = profilePictureUrl;
        enlargedImg.classList.add("enlarged-profile-picture");
        document.body.appendChild(enlargedImg);
        img.addEventListener("mouseover", () => {
          enlargedImg.style.display = "block";
          const rect = img.getBoundingClientRect();
          enlargedImg.style.top = `${rect.top + window.scrollY + 20}px`;
          enlargedImg.style.left = `${rect.left + window.scrollX + 20}px`;
        });
        img.addEventListener("mouseout", () => {
          enlargedImg.style.display = "none";
        });
      }
    });
    console.log("Profile pictures injected");
  }

  function setupObserver() {
    console.log("Setting up observer");
    const observer = new MutationObserver((mutations) => {
      const comments = document.querySelectorAll(".author, .c-username");
      if (comments.length > 0) {
        console.log("New comments detected");
        observer.disconnect();
        injectProfilePictures(comments);
      }
    });
    observer.observe(document.body, {
      childList: true,
      subtree: true,
    });
    console.log("Observer initialized");
  }

  function runScript() {
    flushOldCache();
    console.log("Cache loaded:", profilePictureCache);
    setupObserver();
  }

  window.addEventListener("load", () => {
    console.log("Page loaded");
    runScript();
    setInterval(runScript, 10000); // Run every 10 seconds
  });

  const style = document.createElement("style");
  style.textContent = `
          .profile-picture {
              width: 20px;
              height: 20px;
              border-radius: 50%;
              margin-right: 5px;
              transition: transform 0.2s ease-in-out;
              position: relative;
              z-index: 1;
              cursor: pointer;
          }
          .enlarged-profile-picture {
              width: 250px;
              height: 250px;
              border-radius: 50%;
              position: absolute;
              display: none;
              z-index: 1000;
              pointer-events: none;
              outline: 3px solid #000;
              box-shadow: 0 4px 8px rgba(0, 0, 0, 1);
              background-color: rgba(0, 0, 0, 1);
          }
      `;
  document.head.appendChild(style);
})();