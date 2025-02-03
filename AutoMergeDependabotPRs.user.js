// ==UserScript==
// @name         Auto Merge Dependabot PRs with Status and Selection
// @namespace    typpi.online
// @version      1.6
// @description  Automatically clicks the merge button on selected Dependabot PRs and "Done" button on the notification bar and shows status messages
// @author       Nick2bad4u
// @match        https://github.com/*/*/pulls
// @grant        none
// @icon         https://www.google.com/s2/favicons?sz=64&domain=github.com
// @license      UnLicense
// ==/UserScript==

(function () {
	'use strict';

	let observer;
	let statusElement;
	let statusTimeout;

	function showStatus(message, isSuccess) {
		if (!statusElement) {
			statusElement = document.createElement('div');
			statusElement.style.position = 'fixed';
			statusElement.style.bottom = '10px';
			statusElement.style.right = '10px';
			statusElement.style.padding = '10px';
			statusElement.style.color = 'white';
			statusElement.style.zIndex = '1000';
			document.body.appendChild(statusElement);
		}

		statusElement.textContent = message;
		statusElement.style.backgroundColor = isSuccess ? 'green' : 'red';
		statusElement.style.display = 'block';

		if (statusTimeout) {
			clearTimeout(statusTimeout);
		}
		statusTimeout = setTimeout(() => {
			statusElement.style.display = 'none';
		}, 3000);
	}

	function checkAndMerge() {
		const selectedPRs = document.querySelectorAll('input[type="checkbox"].pr-checkbox:checked');
		if (selectedPRs.length === 0) {
			showStatus('No PRs selected for merging', false);
			return;
		}

		selectedPRs.forEach((checkbox) => {
			const prElement = checkbox.closest('.js-issue-row');
			const authorElement = prElement.querySelector('.opened-by a');
			if (authorElement && /dependabot(\[bot\])?|Nick2bad4u/.test(authorElement.textContent.trim())) {
				setTimeout(() => {
					const mergeButton = prElement.querySelector(
						'.btn-group-merge .btn-primary, .merge-message .btn-primary, .merge-box-button .btn-primary, .merge-status-details .btn-primary',
					);

					if (mergeButton && !mergeButton.disabled) {
						console.log('Merge button is enabled, clicking it');
						mergeButton.click();
						showStatus('Merge button clicked', true);
					} else {
						console.log('Merge button is disabled or not found');
						showStatus('Merge button is disabled or not found', false);
					}
				}, 500);
			} else {
				console.log('PR is not created by dependabot');
				showStatus('PR is not created by dependabot', false);
			}
		});
	}

	function addUI() {
		const prList = document.querySelectorAll('.js-issue-row');
		prList.forEach((pr) => {
			const checkbox = document.createElement('input');
			checkbox.type = 'checkbox';
			checkbox.classList.add('pr-checkbox');
			pr.querySelector('.d-flex').prepend(checkbox);
		});

		const mergeButton = document.createElement('button');
		mergeButton.textContent = 'Merge Selected PRs';
		mergeButton.style.position = 'fixed';
		mergeButton.style.top = '10px';
		mergeButton.style.right = '10px';
		mergeButton.style.padding = '10px';
		mergeButton.style.backgroundColor = 'blue';
		mergeButton.style.color = 'white';
		mergeButton.style.zIndex = '1000';
		mergeButton.addEventListener('click', checkAndMerge);
		document.body.appendChild(mergeButton);
	}

	globalThis.addEventListener(
		'load',
		function () {
			console.log('Page loaded');

			const targetNode = document.querySelector('.js-navigation-container');
			if (!targetNode) {
				console.log('Target node for observation not found');
				showStatus('Target node for observation not found', false);
				return;
			}

			observer = new MutationObserver((mutationsList) => {
				for (const mutation of mutationsList) {
					if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
						console.log('Relevant DOM mutation detected');
						addUI();
						break;
					}
				}
			});

			observer.observe(targetNode, {
				childList: true,
				subtree: true,
			});
			addUI();
		},
		false,
	);
})();
