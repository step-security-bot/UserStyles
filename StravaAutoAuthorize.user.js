// ==UserScript==
// @name         Strava Auto Authorize Apps
// @namespace    typpi.online
// @description  Auto allows Strava apps without having to click "authorize" every single time.
// @author       Nick2bad4u
// @match        https://www.strava.com/oauth/authorize*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=strava.com
// @version      2.3
// @grant        none
// @homepageURL  https://github.com/Nick2bad4u/UserStyles
// @supportURL   https://github.com/Nick2bad4u/UserStyles/issues
// @license      Unlicense
// @resource     https://www.google.com/s2/favicons?sz=64&domain=reddit.com
// @icon         https://www.google.com/s2/favicons?sz=64&domain=reddit.com
// @icon64       https://www.google.com/s2/favicons?sz=64&domain=reddit.com
// @downloadURL  https://update.greasyfork.org/scripts/514687/Strava-Auto-Authorize.user.js
// @updateURL    https://update.greasyfork.org/scripts/514687/Strava-Auto-Authorize.meta.js
// ==/UserScript==

setTimeout(function () {
	document
		.getElementsByClassName('btn')[0]
		.click();
}, 1000);
