// ==UserScript==
// @name         Left-Right Balance for Strava [Updated]
// @namespace    typpi.online
// @description  Shows your Left/Right balance under the analysis section on Strava.
// @version      1.5
// @include      https://www.strava.com/activities/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=strava.com
// @author       Nick2bad4u
// @license      UnLicense
// @grant        none
// @homepageURL  https://userstyles.github.typpi.online
// @downloadURL  https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/strava-balance/Strava-Add-Balance-Updated.user.js
// @updateURL    https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/strava-balance/Strava-Add-Balance-Updated.user.js
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
