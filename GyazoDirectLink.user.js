// ==UserScript==
// @name         Gyazo Gif and Video Direct Link Button
// @namespace    typpi.online
// @version      1.7
// @description  Adds a link button to redirect to the direct video or gif link on Gyazo
// @author       Nick2bad4u
// @license      UnLicense
// @homepageURL  https://github.com/Nick2bad4u/UserStyles
// @supportURL   https://github.com/Nick2bad4u/UserStyles/issues
// @match        https://gyazo.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=gyazo.com
// @grant        none
// ==/UserScript==

(function () {
	'use strict';

	function addRedirectButton() {
		// Remove existing button if it exists
		const existingButton = document.getElementById('direct-video-link-button');
		if (existingButton) {
			existingButton.remove();
		}

		const videoElement = document.querySelector('#gyazo-video-player > video');
		const targetElement = document.querySelector(
			'#react-root > div.header-block.explorer-header-block > div.explorer-action-btn-toolbar > div.explorer-action-btn-group',
		);

		if (videoElement && targetElement) {
			const button = document.createElement('button');
			button.id = 'direct-video-link-button';
			button.setAttribute(
				'class',
				'btn explorer-action-btn explorer-action-btn-dark',
			);
			button.setAttribute('data-tooltip-content', 'Direct Link');

			const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
			svg.setAttribute('width', '24');
			svg.setAttribute('height', '24');
			svg.setAttribute('viewBox', '0 0 24 24');
			svg.setAttribute('class', 'icon-link'); // Updated class for link icon

			const path = document.createElementNS(
				'http://www.w3.org/2000/svg',
				'path',
			);
			path.setAttribute(
				'd',
				'M3.9 11.1c-.4.4-.4 1 0 1.4l6.6 6.6c.4.4 1 .4 1.4 0l3.6-3.6c.4-.4.4-1 0-1.4-.4-.4-1-.4-1.4 0L10 16.6l-5.3-5.3 2.5-2.5c.4-.4.4-1 0-1.4-.4-.4-1-.4-1.4 0l-3.6 3.6zM20.1 3.9c-.4-.4-1-.4-1.4 0l-3.6 3.6c-.4.4-.4 1 0 1.4.4.4 1 .4 1.4 0l2.5-2.5L14 10l-6.6-6.6c-.4-.4-1-.4-1.4 0l-3.6 3.6c-.4.4-.4 1 0 1.4.4.4 1 .4 1.4 0L10 3.4l5.3 5.3-2.5 2.5c-.4.4-.4 1 0 1.4.4.4 1 .4 1.4 0l3.6-3.6c.4-.4.4-1 0-1.4L13.6 2c-.4-.4-1-.4-1.4 0L4.6 9.6c-.4.4-.4 1 0 1.4.4.4 1 .4 1.4 0l5.3-5.3L14 10l6.6-6.6c.4-.4.4-1 0-1.4z',
			); // Link icon path

			svg.appendChild(path);
			button.appendChild(svg);

			// Create tooltip element
			const tooltip = document.createElement('div');
			tooltip.id = 'tooltip-direct-video-link-button';
			tooltip.setAttribute('role', 'tooltip');
			tooltip.setAttribute(
				'class',
				'react-tooltip core-styles-module_tooltip__3vRRp styles-module_tooltip__mnnfp styles-module_dark__xNqje react-tooltip__place-bottom core-styles-module_show__Nt9eE react-tooltip__show',
			);
			tooltip.style.cssText =
				'z-index: 2147483647; font-size: 14px; padding: 6px 10px; max-width: 250px; display: none; position: absolute;';
			tooltip.innerHTML =
				'Direct Link<div class="react-tooltip-arrow core-styles-module_arrow__cvMwQ styles-module_arrow__K0L3T" style="left: 38px; top: -4px;"></div>';

			document.body.appendChild(tooltip);

			// Show tooltip on hover
			button.onmouseover = function () {
				const rect = button.getBoundingClientRect();
				tooltip.style.left = rect.left + window.scrollX - 18.9453 + 'px';
				tooltip.style.top = rect.top + window.scrollY + 42 + 'px';
				tooltip.style.display = 'block';
			};

			// Hide tooltip on mouseout
			button.onmouseout = function () {
				tooltip.style.display = 'none';
			};

			// Extract the unique identifier from the current URL
			const urlPath = window.location.pathname.split('/')[1];
			const directLink = `https://i.gyazo.com/${urlPath}.mp4`;

			button.onclick = function () {
				window.location.href = directLink;
			};

			// Insert the button to the left of the target element
			targetElement.insertAdjacentElement('beforebegin', button);
		}
	}

	// Initial run at document-idle
	window.addEventListener('load', addRedirectButton);

	// Observe changes in the URL to update the button
	let lastUrl = location.href;
	new MutationObserver(() => {
		const currentUrl = location.href;
		if (lastUrl !== currentUrl) {
			lastUrl = currentUrl;
			addRedirectButton();
		}
	}).observe(document, {
		subtree: true,
		childList: true,
	});
})();
