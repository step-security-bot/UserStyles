// ==UserScript==
// @name         Left-Right Balance for Strava [Updated]
// @namespace    typpi.online
// @description  Shows your Left/Right balance under the analysis section on Strava.
// @version      2.7
// @include      https://www.strava.com/activities/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=strava.com
// @author       Nick2bad4u
// @license      UnLicense
// @grant        none
// @homepageURL  https://github.com/Nick2bad4u/UserStyles
// @downloadURL https://update.greasyfork.org/scripts/524193/Left-Right%20Balance%20for%20Strava%20%5BUpdated%5D.user.js
// @updateURL https://update.greasyfork.org/scripts/524193/Left-Right%20Balance%20for%20Strava%20%5BUpdated%5D.meta.js
// ==/UserScript==

/**
 * URL of the script to be loaded from the CDN.
 * This script is hosted on jsDelivr and is part of the UserStyles repository.
 *
 * @constant {string}
 */
const scriptURL = 'https://cdn.jsdelivr.net/gh/Nick2bad4u/UserStyles@main/strava-balance/Strava-AddBalance.js';
// Cache expiration time set to 24 hours in milliseconds
const cacheExpirationTime = 24 * 60 * 60 * 1000;
// Key used to store the last fetch time of the script in localStorage
const lastFetchTimeKey = 'stravaBalanceScriptFetchTime';

//balanceScriptElement.src="https://dmwnz.github.io/lrbalance4strava/addbal.js";

/**
 * Determines if the cache has expired based on the last fetch time and the cache expiration time.
 *
 * @param {number} lastFetchTime - The timestamp of the last fetch.
 * @param {number} cacheExpirationTime - The duration in milliseconds after which the cache is considered expired.
 * @returns {boolean} - Returns true if the cache is expired, otherwise false.
 */
const isCacheExpired = (lastFetchTime, cacheExpirationTime) => {
	const currentTime = Date.now();
	return !lastFetchTime || currentTime - Number(lastFetchTime) > cacheExpirationTime;
};

/**
 * Immediately Invoked Function Expression (IIFE) to load and execute the Strava balance script.
 * It checks the cache for the script and fetches it from the network if the cache is expired.
 */
async function loadStravaBalanceScript() {
	try {
		const cachedScriptKey = 'stravaBalanceScript';
		const cachedScript = localStorage.getItem(cachedScriptKey);
		const lastFetchTime = localStorage.getItem(lastFetchTimeKey);

		// Check if the cached script exists and if it has not expired
		const cacheExpired = isCacheExpired(Number(lastFetchTime), cacheExpirationTime);
		if (cachedScript && !cacheExpired) {
			/**
			 * Creates a new script element to be used for adding balance functionality.
			 * @type {HTMLScriptElement}
			 */
			const balanceScriptElement = document.createElement('script');
			balanceScriptElement.type = 'module';
			balanceScriptElement.text = cachedScript;
			document.body.appendChild(balanceScriptElement);
		} else {
			/**
			 * Fetches a script from the specified URL.
			 *
			 * @param {string} scriptURL - The URL of the script to be fetched.
			 * @returns {Promise<Response>} A promise that resolves to the response from the fetch call.
			 */
			const controller = new AbortController();
			const timeoutId = setTimeout(() => controller.abort(), 5000); // 5 seconds timeout
			let response;
			try {
				response = await fetch(scriptURL, { signal: controller.signal });
			} catch (error) {
				if (error.name === 'AbortError') {
					console.error('Fetch request timed out');
				} else {
					console.error('Error fetching script:', error);
				}
				clearTimeout(timeoutId);
				return;
			}
			clearTimeout(timeoutId);
			if (!response.ok) {
				throw new Error(`HTTP error! status: ${response.status}`);
			}
			const data = await response.text();
			localStorage.setItem(cachedScriptKey, data);
			localStorage.setItem(lastFetchTimeKey, Date.now().toString());
			const balanceScriptElement = document.createElement('script');
			balanceScriptElement.type = 'module';
			balanceScriptElement.text = data;
			document.body.appendChild(balanceScriptElement);
		}
		const scriptSource = cachedScript && !cacheExpired ? 'cache' : 'network';
		console.log(`Strava balance script loaded from ${scriptSource === 'cache' ? 'cache' : 'network'} and executed successfully.`);
	} catch (error) {
		console.error('Error loading script:', error);
	}
}

loadStravaBalanceScript();
