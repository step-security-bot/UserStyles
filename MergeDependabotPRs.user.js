// ==UserScript==
// @name         Auto-Merge Dependabot PRs
// @namespace    typpi.online
// @version      2.0
// @description  Merges Dependabot PRs in any of your repositories
// @var          number merge_delay "Delay between merge requests in milliseconds" 2000
// @author       Nick2bad4u
// @match        https://github.com/notifications
// @grant        GM_xmlhttpRequest
// @grant        GM_addStyle
// @grant        GM_getValue
// @grant        GM_setValue
// @connect      api.github.com
// @license      MIT
// @icon         https://www.google.com/s2/favicons?sz=64&domain=github.com
// @homepageURL  https://github.com/Nick2bad4u/UserStyles
// @supportURL   https://github.com/Nick2bad4u/UserStyles/issues
// ==/UserScript==
/* global GM_getValue, GM_setValue, GM_xmlhttpRequest */
(async function () {
	'use strict';

	// Delay between each merge request in milliseconds, default is 2000ms
	let delay = GM_getValue('merge_delay', 2000);
	if (isNaN(delay) || Number(delay) <= 0) {
		delay = 2000; // default value if invalid
	} else {
		delay = Number(delay);
	}

	async function initialize() {
		let token;
		try {
			// Attempt to retrieve and decrypt the GitHub token
			token = await retrieveAndDecryptToken();
		} catch (error) {
			console.error('Failed to retrieve and decrypt token:', error);
			alert('Failed to retrieve and decrypt token. Please check the console for more details.');
			return;
		}

		// Prompt the user for the token if it was not successfully retrieved
		if (!token) {
			while (!token) {
				token = prompt('Please enter your GitHub token:');
				if (!token) {
					alert('GitHub token is required.');
				}
			}
			// Encrypt and store the token if it was provided
			if (token) {
				try {
					await encryptAndStoreToken(token);
				} catch (error) {
					console.error('Failed to encrypt and store token:', error);
					alert('Failed to encrypt and store token. Please check the console for more details.');
					return;
				}
			} else {
				alert('GitHub token is required.');
				return;
			}
		}

		// Retrieve the GitHub username from storage or prompt the user for it
		let username = GM_getValue('github_username');
		while (!username) {
			username = prompt('Please enter your GitHub username:');
			if (username) {
				GM_setValue('github_username', username);
			} else {
				alert('GitHub username is required.');
			}
		}

		// Retrieve the GitHub repository name from storage or prompt the user for it
		let repo = GM_getValue('github_repo');
		while (!repo) {
			repo = prompt('Please enter your GitHub repository name:');
			if (repo) {
				GM_setValue('github_repo', repo);
			} else {
				alert('GitHub repository name is required.');
			}
		}
	}

	await initialize();

	async function encryptAndStoreToken(token) {
		try {
			// Create a new TextEncoder instance to encode the token
			const textEncoder = new TextEncoder();
			const encodedToken = textEncoder.encode(token);

			let key;
			// Retrieve the stored encryption key from storage
			const storedKey = GM_getValue('encryption_key', null);
			if (storedKey) {
				// If a key is already stored, import it for use
				key = await crypto.subtle.importKey(
					'jwk',
					JSON.parse(storedKey),
					{
						name: 'AES-GCM',
					},
					true,
					['encrypt', 'decrypt'],
				);
			} else {
				// If no key is stored, generate a new one
				key = await crypto.subtle.generateKey(
					{
						name: 'AES-GCM',
						length: 256,
					},
					true,
					['encrypt', 'decrypt'],
				);
				// Store the newly generated key
				GM_setValue('encryption_key', JSON.stringify(await crypto.subtle.exportKey('jwk', key)));
			}

			// Create a random initialization vector (iv)
			const iv = crypto.getRandomValues(new Uint8Array(12));
			// Encrypt the token using the imported or generated key and the iv
			const encryptedToken = await crypto.subtle.encrypt(
				{
					name: 'AES-GCM',
					iv: iv,
				},
				key,
				encodedToken,
			);

			// Store the encrypted token and iv in storage
			GM_setValue(
				'github_token',
				JSON.stringify({
					iv: Array.from(iv),
					token: Array.from(new Uint8Array(encryptedToken)),
				}),
			);
		} catch (error) {
			console.error('Failed to encrypt and store token:', error);
		}
	}

	async function retrieveAndDecryptToken() {
		try {
			// Retrieve the stored encrypted token and encryption key from storage
			const storedData = GM_getValue('github_token', null);
			if (!storedData) return '';

			// Parse the stored data to extract the initialization vector (iv) and the token
			const { key, iv, token } = JSON.parse(storedData);

			// Import the encryption key for decryption
			const importedKey = await crypto.subtle.importKey(
				'jwk',
				key,
				{
					name: 'AES-GCM',
				},
				true,
				['decrypt'],
			);

			// Decrypt the token using the imported key and initialization vector
			const decryptedToken = await crypto.subtle.decrypt(
				{
					name: 'AES-GCM',
					iv: new Uint8Array(iv),
				},
				importedKey,
				new Uint8Array(token),
			);

			// Decode the decrypted token into a string and return it
			const textDecoder = new TextDecoder();
			return textDecoder.decode(decryptedToken);
		} catch (error) {
			console.error('Failed to retrieve and decrypt token:', error);
			return '';
		}
	}

	async function fetchDependabotPRs(username, repo, token) {
		return new Promise((resolve, reject) => {
			GM_xmlhttpRequest({
				method: 'GET',
				url: `https://api.github.com/repos/${username}/${repo}/pulls?per_page=100&state=open&user=dependabot[bot]`,
				headers: {
					Authorization: `token ${token}`,
				},
				onload: function (response) {
					if (response.status === 200) {
						const pulls = JSON.parse(response.responseText);
						resolve(pulls);
					} else {
						reject(new Error(`Failed to fetch pull requests: ${response.responseText}`));
					}
				},
				onerror: function (error) {
					reject(error);
				},
			});
		});
	}

	async function mergeDependabotPRs(prs, username, repo, token) {
		const statusContainer = document.getElementById('merge-status');
		let index = 0;

		async function processNextPR() {
			if (index < prs.length) {
				const pr = prs[index];
				try {
					await mergePR(pr, username, repo, token);
					statusContainer.innerHTML += `PR #${pr.number} merged successfully!<br>`;
				} catch (error) {
					statusContainer.innerHTML += `Failed to merge PR #${pr.number}: ${error.message}<br>`;
				}
				index++;
				setTimeout(processNextPR, delay); // configurable delay between each request
			}
		}

		processNextPR();
	}

	function mergePR(pr, username, repo, token) {
		return new Promise((resolve, reject) => {
			GM_xmlhttpRequest({
				method: 'PUT',
				url: `https://api.github.com/repos/${username}/${repo}/pulls/${pr.number}/merge`,
				headers: {
					Authorization: `token ${token}`,
					'Content-Type': 'application/json',
				},
				data: JSON.stringify({
					commit_title: `Merge PR #${pr.number}`,
					merge_method: 'merge',
				}),
				onload: function (response) {
					if (response.status === 200) {
						resolve();
					} else {
						reject(new Error(response.responseText));
					}
				},
				onerror: function (error) {
					reject(error);
				},
			});
		});
	}

	function addButton() {
		const mergeButton = document.createElement('mergebutton');
		mergeButton.textContent = 'Merge Dependabot PRs';
		mergeButton.style = 'position: fixed; bottom: 10px; right: 10px; z-index: 1000;';
		mergeButton.addEventListener('click', async () => {
			try {
				const token = await retrieveAndDecryptToken();
				if (!token) {
					alert('Invalid or missing GitHub token. Please check your settings.');
					return;
				}
				const username = GM_getValue('github_username');
				const repo = GM_getValue('github_repo');
				const prs = await fetchDependabotPRs(username, repo, token);
				if (prs.length > 0) {
					displayPRSelection(prs, username, repo, token);
				} else {
					displayNoPRsMessage();
				}
			} catch (error) {
				console.error('Error during merge operation:', error);
			}
		});
		document.body.appendChild(mergeButton);
	}

	function displayPRSelection(prs, username, repo, token) {
		const container = document.createElement('div');
		style.textContent += `
			.pr-selection-container {
				position: fixed;
				bottom: 50px;
				right: 10px;
				z-index: 1000;
				background: white;
				padding: 10px;
				border: 1px solid #ccc;
				max-height: 300px;
				overflow-y: auto;
			}
		`;
		container.classList.add('pr-selection-container');

		const prList = document.createElement('div');
		prs.forEach((pr) => {
			const prItem = document.createElement('div');
			const checkbox = document.createElement('input');
			checkbox.type = 'checkbox';
			checkbox.value = pr.number;

			const label = document.createElement('label');
			label.textContent = `PR #${pr.number}: ${pr.title}`;
			label.style = 'margin-left: 5px;';

			prItem.appendChild(checkbox);
			prItem.appendChild(label);
			prList.appendChild(prItem);
		});

		const mergeSelectedButton = document.createElement('button');
		mergeSelectedButton.textContent = 'Merge Selected PRs';
		mergeSelectedButton.addEventListener('click', async () => {
			const selectedPRs = Array.from(prList.querySelectorAll('input:checked')).map((input) => prs.find((pr) => pr.number == input.value));
			if (selectedPRs.length > 0) {
				container.innerHTML = '<div id="merge-status">Merging PRs...<br></div>';
				await mergeDependabotPRs(selectedPRs, username, repo, token);
			} else {
				container.innerHTML = 'No PRs selected for merging.';
			}
		});

		container.appendChild(prList);
		container.appendChild(mergeSelectedButton);
		document.body.appendChild(container);
	}

	function displayNoPRsMessage() {
		const container = document.createElement('div');
		container.classList.add('pr-container');
		container.textContent = 'No Dependabot PRs found to merge.';
		document.body.appendChild(container);

		// Automatically hide the message after 5 seconds (5000 milliseconds)
		setTimeout(() => {
			container.remove();
		}, 5000);
	}

	const style = document.createElement('style');
	style.textContent = `
			mergebutton {
					background-color: #2ea44f;
					color: #ffffff;
					border: none;
					padding: 10px;
					border-radius: 5px;
					cursor: pointer;
			}
			mergebutton:hover {
					background-color: #79e4f2;
					color: #ffffff;
					border: none;
					padding: 10px;
					border-radius: 5px;
					cursor: pointer;
			}
			#merge-status {
					margin-top: 10px;
					font-size: 0.9em;
					color: #333;
					background-color: #79e4f2;
			}
			.pr-container {
				background-color: #ff0000;
				color: #ffffff;
				position: fixed;
				bottom: 50px;
				right: 10px;
				z-index: 1000;
				padding: 10px;
				border: 1px solid #cccccc;
	}
	`;
	document.head.appendChild(style);
	window.addEventListener('load', addButton);
})();
