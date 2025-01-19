// ==UserScript==
// @name         Left-Right Balance for Strava [Updated]
// @namespace    typpi.online
// @description  Shows your Left/Right balance under the analysis section on Strava.
// @version      2.1
// @include      https://www.strava.com/activities/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=strava.com
// @author       Nick2bad4u
// @license      UnLicense
// @grant        none
// @homepageURL  https://userstyles.github.typpi.online
// @downloadURL  https://update.greasyfork.org/scripts/524193/Left-Right%20Balance%20for%20Strava%20%5BUpdated%5D.user.js
// @updateURL    https://update.greasyfork.org/scripts/524193/Left-Right%20Balance%20for%20Strava%20%5BUpdated%5D.meta.js
// ==/UserScript==

var q = document.createElement('script');
q.type="module";
//q.src="https://dmwnz.github.io/lrbalance4strava/addbal.js";

const req = new XMLHttpRequest();
req.open('GET', "https://cdn.jsdelivr.net/gh/Nick2bad4u/UserStyles@refs/heads/main/strava-balance/Strava-AddBalance.js", true);
req.onload = (event) => {
  q.text = req.response;
}
req.send();

document.body.appendChild(q);

console.log('bye !');
