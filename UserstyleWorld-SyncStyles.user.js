// ==UserScript==
// @name         Userstyle World - Auto Sync UserStyles with Selection UI
// @namespace    typpi.online
// @version      1.7
// @description  Automatically sync userstyles by visiting the mirror URL with a selection UI
// @author       Nick2bad4u
// @license      UnLicense
// @homepageURL  https://github.com/Nick2bad4u/UserStyles
// @supportURL   https://github.com/Nick2bad4u/UserStyles/issues
// @icon         https://www.google.com/s2/favicons?sz=64&domain=userstyles.world
// @match        *://userstyles.world/*
// @grant        none
// @downloadURL https://update.greasyfork.org/scripts/524688/Userstyle%20World%20-%20Auto%20Sync%20UserStyles%20with%20Selection%20UI.user.js
// @updateURL   https://update.greasyfork.org/scripts/524688/Userstyle%20World%20-%20Auto%20Sync%20UserStyles%20with%20Selection%20UI.meta.js
// ==/UserScript==

(function () {
	'use strict';

	function getStyleIDs() {
		const styleLinks = document.querySelectorAll('a.card-header.thumbnail');
		const styleIDs = [];
		styleLinks.forEach((link) => {
			const href = link.getAttribute('href');
			const match = href.match(/\/style\/(\d+)\//);
			if (match) {
				styleIDs.push(match[1]);
			}
		});
		return styleIDs;
	}

	function visitMirrorURL(styleID) {
		const mirrorURL = `https://userstyles.world/mirror/${styleID}`;
		fetch(mirrorURL)
			.then((response) => {
				if (response.ok) {
					updateStatus(`Successfully visited ${mirrorURL}`);
				} else {
					updateStatus(`Failed to visit ${mirrorURL}`);
				}
			})
			.catch((error) => {
				updateStatus(`Error visiting ${mirrorURL}: ${error}`);
			});
	}

	function updateStatus(message) {
		const statusElement = document.getElementById('sync-status');
		if (statusElement) {
			statusElement.textContent = message;
		}
	}

	function createUI(styleIDs) {
		const container = document.createElement('div');
		container.style.position = 'fixed';
		container.style.bottom = '10px';
		container.style.right = '10px';
		container.style.width = '250px';
		container.style.backgroundColor = '#000';
		container.style.border = '1px solid #5a4ebc';
		container.style.borderRadius = '5px';
		container.style.padding = '15px';
		container.style.boxShadow = '0 2px 10px #0000001a';
		container.style.zIndex = '1000';
		container.style.maxHeight = '50vh';
		container.style.overflowY = 'auto'; // Make the container scrollable

		const titleContainer = document.createElement('div');
		titleContainer.style.display = 'flex';
		titleContainer.style.justifyContent = 'space-between';
		titleContainer.style.alignItems = 'center';
		container.appendChild(titleContainer);

		const title = document.createElement('h3');
		title.textContent = 'Select Styles to Sync';
		title.style.marginBottom = '10px';
		title.style.fontSize = '16px';
		title.style.fontWeight = 'bold';
		titleContainer.appendChild(title);

		const minimizeButton = document.createElement('button');
		minimizeButton.textContent = '-';
		minimizeButton.style.background = 'none';
		minimizeButton.style.border = 'none';
		minimizeButton.style.cursor = 'pointer';
		minimizeButton.style.fontSize = '16px';
		minimizeButton.style.marginBottom = '10px';
		titleContainer.appendChild(minimizeButton);

		minimizeButton.onclick = () => {
			const isMinimized = container.getAttribute('data-minimized') === 'true';
			container.setAttribute('data-minimized', !isMinimized);
			form.style.display = isMinimized ? 'block' : 'none';
			selectAllButton.style.display = isMinimized ? 'block' : 'none';
			button.style.display = isMinimized ? 'block' : 'none';
			status.style.display = isMinimized ? 'block' : 'none';
		};

		const selectAllButton = document.createElement('button');
		selectAllButton.textContent = 'Select All';
		selectAllButton.type = 'button';
		selectAllButton.style.display = 'block';
		selectAllButton.style.width = '100%';
		selectAllButton.style.padding = '10px';
		selectAllButton.style.backgroundColor = '#28a745';
		selectAllButton.style.color = '#fff';
		selectAllButton.style.border = 'none';
		selectAllButton.style.borderRadius = '5px';
		selectAllButton.style.cursor = 'pointer';
		selectAllButton.style.fontSize = '14px';
		selectAllButton.style.marginBottom = '10px';

		selectAllButton.onclick = () => {
			form
				.querySelectorAll('input[type="checkbox"]')
				.forEach((checkbox) => (checkbox.checked = true));
		};
		container.appendChild(selectAllButton);

		const form = document.createElement('form');
		styleIDs.forEach((styleID) => {
			const label = document.createElement('label');
			label.style.display = 'flex';
			label.style.alignItems = 'center';
			label.style.marginBottom = '8px';

			const checkbox = document.createElement('input');
			checkbox.type = 'checkbox';
			checkbox.value = styleID;
			checkbox.style.setProperty('margin-right', '10px', 'important');
			checkbox.style.opacity = '1';

			label.appendChild(checkbox);
			label.appendChild(document.createTextNode(`Style ID: ${styleID}`));
			form.appendChild(label);
		});

		const button = document.createElement('button');
		button.textContent = 'Sync Selected Styles';
		button.type = 'button';
		button.style.display = 'block';
		button.style.width = '100%';
		button.style.padding = '10px';
		button.style.backgroundColor = '#007bff';
		button.style.color = '#fff';
		button.style.border = 'none';
		button.style.borderRadius = '5px';
		button.style.cursor = 'pointer';
		button.style.fontSize = '14px';
		button.style.marginTop = '10px';
		button.onmouseover = () => {
			button.style.backgroundColor = '#0056b3';
		};
		button.onmouseout = () => {
			button.style.backgroundColor = '#007bff';
		};

		button.onclick = () => {
			const selectedIDs = Array.from(
				form.querySelectorAll('input[type="checkbox"]:checked'),
			).map((input) => input.value);
			if (selectedIDs.length > 0) {
				selectedIDs.forEach((styleID) => visitMirrorURL(styleID));
			} else {
				updateStatus('No styles selected.');
			}
		};

		const status = document.createElement('div');
		status.id = 'sync-status';
		status.style.marginTop = '10px';
		status.style.fontSize = '12px';
		status.style.color = '#333';

		container.appendChild(form);
		container.appendChild(button);
		container.appendChild(status);
		document.body.appendChild(container);
	}

	function main() {
		const styleIDs = getStyleIDs();
		if (styleIDs.length > 0) {
			createUI(styleIDs);
		} else {
			console.warn('No style IDs found on the page.');
		}
	}

	main();
})();
