// ==UserScript==
// @name         Reddit-Stream Auto-Refresh
// @namespace    nick2bad4u
// @description  Auto-Refreshes your Reddit-Stream.com page every 30 seconds. Modify the script and change to any time you want.
// @author       Nick2bad4u
// @match        https://reddit-stream.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=reddit-stream.com
// @version      2.1
// @grant        none
// @homepage     https://github.com/Nick2bad4u/RedditCommentStreamRefresh
// @homepageURL  https://github.com/Nick2bad4u/RedditCommentStreamRefresh
// @supportURL   https://github.com/Nick2bad4u/RedditCommentStreamRefresh/issues
// @downloadURL  https://github.com/Nick2bad4u/UserStyles/blob/main/RedditStreamAutoRefresher.user.js
// @updateURL    https://github.com/Nick2bad4u/UserStyles/blob/main/RedditStreamAutoRefresher.user.js
// @license CC-BY-SA-3.0; http://creativecommons.org/licenses/by-sa/3.0/
// @license MIT
// ==/UserScript==

(function () {
  'use strict';
  setTimeout(function () {
    location.reload();
  }, 30 * 1000);
})();
