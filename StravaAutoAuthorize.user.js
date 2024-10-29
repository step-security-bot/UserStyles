// ==UserScript==
// @name         Strava-Auto-Authorize
// @namespace    nick2bad4u
// @description  Auto allows Strava apps without having to click "authorize" every single time.
// @author       Nick2bad4u
// @match        https://www.strava.com/oauth/authorize*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=strava.com
// @version      2.0
// @grant        none
// @homepage     https://github.com/Nick2bad4u/StravaAutoAuthorize
// @homepageURL  https://github.com/Nick2bad4u/StravaAutoAuthorize
// @supportURL   https://github.com/Nick2bad4u/StravaAutoAuthorize/issues
// @downloadURL  https://github.com/Nick2bad4u/UserStyles/blob/main/StravaAutoAuthorize.user.js
// @updateURL    https://github.com/Nick2bad4u/UserStyles/blob/main/StravaAutoAuthorize.user.js
// @license CC-BY-SA-3.0; http://creativecommons.org/licenses/by-sa/3.0/
// @license MIT
// ==/UserScript==

setTimeout(function() {
    document.getElementsByClassName("btn")[0].click();
}, 1000)
