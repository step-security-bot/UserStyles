// ==UserScript==
// @name         Left-Right Balance for Strava [Updated Original]
// @namespace    typpi.online
// @description  Shows your Left/Right balance under the analysis section on Strava.
// @version      1.5
// @include      https://www.strava.com/activities/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=strava.com
// @author       Nick2bad4u
// @license      UnLicense
// @grant        none
// @homepageURL  https://userstyles.github.typpi.online
// @downloadURL  https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/strava-balance/Strava-Add-Balance-Updated-Short.user.js
// @updateURL    https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/strava-balance/Strava-Add-Balance-Updated-Short.user.js
// ==/UserScript==

var q = document.createElement('script');
q.type="module";
//q.src="https://dmwnz.github.io/lrbalance4strava/addbal.js";
//q.src="https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/strava-balance/Strava-AddBalance.js";

const req = new XMLHttpRequest();
req.open('GET', "https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/strava-balance/Strava-AddBalance.js", true);
req.onload = (event) => {
  q.text = req.response;
}
req.send();

document.body.appendChild(q);

console.log('bye !');
