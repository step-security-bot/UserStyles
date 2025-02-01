// ==UserScript==
// @name         Auto-Merge Dependabot PRs
// @namespace    typpi.online
// @version      1.3
// @description  Merges Dependabot PRs in any of your repositories
// @var          number merge_delay "Delay between merge requests in milliseconds" 2000 // The delay in milliseconds between each merge request
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

	// let repo = GM_getValue('github_repo'); // redundant declaration removed

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
			token = await retrieveAndDecryptToken();
		} catch (error) {
			console.error('Failed to retrieve and decrypt token:', error);
			alert('Failed to retrieve and decrypt token. Please check the console for more details.');
			return;
		}
		if (!token) {
			while (!token) {
				token = prompt('Please enter your GitHub token:');
				if (!token) {
					alert('GitHub token is required.');
				}
			}
			if (token) {
				await encryptAndStoreToken(token);
			} else {
				alert('GitHub token is required.');
				return;
			}
		}
		let username = GM_getValue('github_username');
		while (!username) {
			username = prompt('Please enter your GitHub username:');
			if (username) {
				GM_setValue('github_username', username);
			} else {
				alert('GitHub username is required.');
			}
		}

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
		const enc = new TextEncoder();
		const encodedToken = enc.encode(token);
		let key;
		const storedKey = GM_getValue('encryption_key', null);
		if (storedKey) {
			key = await crypto.subtle.importKey('jwk', JSON.parse(storedKey), { name: 'AES-GCM' }, true, ['encrypt', 'decrypt']);
		} else {
			key = await crypto.subtle.generateKey({ name: 'AES-GCM', length: 256 }, true, ['encrypt', 'decrypt']);
			GM_setValue('encryption_key', JSON.stringify(await crypto.subtle.exportKey('jwk', key)));
		}
		const iv = crypto.getRandomValues(new Uint8Array(12));
		const encryptedToken = await crypto.subtle.encrypt({ name: 'AES-GCM', iv: iv }, key, encodedToken);
		GM_setValue(
			'github_token',
			JSON.stringify({ iv: Array.from(iv), token: Array.from(new Uint8Array(encryptedToken)) }),
		);
	}

	async function retrieveAndDecryptToken() {
		const storedData = GM_getValue('github_token', null);
		if (!storedData) return '';
		const { key, iv, token } = JSON.parse(storedData);
		const importedKey = await crypto.subtle.importKey('jwk', key, { name: 'AES-GCM' }, true, ['decrypt']);
		const decryptedToken = await crypto.subtle.decrypt({ name: 'AES-GCM', iv: new Uint8Array(iv) }, importedKey, new Uint8Array(token));
		const dec = new TextDecoder();
		return dec.decode(decryptedToken);
	}

	async function mergeDependabotPRs(username, repo, token) {
		GM_xmlhttpRequest({
			method: 'GET',
			url: `https://api.github.com/repos/${username}/${repo}/pulls?per_page=100&state=open&user=dependabot[bot]`,
			headers: {
				Authorization: `token ${token}`,
			},
			onload: function (response) {
				const pulls = JSON.parse(response.responseText);
				let index = 0;

				function processNextPR() {
					if (index < pulls.length) {
						const pr = pulls[index];
						mergePR(pr, username, repo, token, function (error) {
							if (error) {
								console.error(`Failed to merge PR #${pr.number}:`, error);
								alert(`Failed to merge PR #${pr.number}. Please check the console for more details.`);
							}
						});
						index++;
						setTimeout(processNextPR, delay); // configurable delay between each request
					}
				}

				processNextPR();
			},
			onerror: function (error) {
				console.error('Failed to fetch pull requests:', error);
				alert('Failed to fetch pull requests. Please check the console for more details.');
			},
		});
	}

	function mergePR(pr, username, repo, token, onerror) {
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
					console.log(`PR #${pr.number} merged successfully!`);
				} else {
					console.error(`Failed to merge PR #${pr.number}:`, response.responseText);
					if (onerror) {
						onerror(new Error(`Failed to merge PR #${pr.number}`));
					}
				}
			},
			onerror: function (error) {
				if (onerror) {
					onerror(error);
				} else {
					console.error(`Failed to merge PR #${pr.number}:`, error);
				}
			},
		});
	}

	function addButton() {
		const button = document.createElement('button');
		button.textContent = 'Merge Dependabot PRs';
		button.style = 'position: fixed; bottom: 10px; right: 10px; z-index: 1000;';
		button.addEventListener('click', async () => {
			const token = await retrieveAndDecryptToken();
			const username = GM_getValue('github_username');
			const repo = GM_getValue('github_repo');
			mergeDependabotPRs(username, repo, token);
		});
		document.body.appendChild(button);
	}

	const style = document.createElement('style');
	style.textContent = `
		button {
			background-color: #2ea44f;
			color: #fff;
			border: none;
			padding: 10px;
			border-radius: 5px;
			cursor: pointer;
		}
	`;
	document.head.appendChild(style);
	window.onload = addButton;
})();
