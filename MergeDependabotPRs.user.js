// ==UserScript==
// @name         Auto-Merge Dependabot PRs
// @namespace    typpi.online
// @version      1.1
// @description  Merges Dependabot PRs in any of your repositories
// @author       Nick2bad4u
// @match        https://github.com/notifications
// @grant        GM_xmlhttpRequest
// @grant        GM_addStyle
// @grant        GM_getValue
// @grant        GM_setValue
// @connect      api.github.com
// @license      MIT
// ==/UserScript==

(function () {
	'use strict';

	// let repo = GM_getValue('github_repo'); // redundant declaration removed

	(async function() {
		let token = await retrieveAndDecryptToken();
		if (!token) {
			token = prompt('Please enter your GitHub token:');
			if (token) {
				await encryptAndStoreToken(token);
			} else {
				alert('GitHub token is required.');
				return;
			}
		}
		let username = GM_getValue('github_username');
		if (!username) {
			username = prompt('Please enter your GitHub username:');
			GM_setValue('github_username', username);
		}

		let repo = GM_getValue('github_repo');
		if (!repo) {
			repo = prompt('Please enter your GitHub repository name:');
			GM_setValue('github_repo', repo);
		}
	})();

	async function encryptAndStoreToken(token) {
		const enc = new TextEncoder();
		const encodedToken = enc.encode(token);
		const key = await crypto.subtle.generateKey({ name: 'AES-GCM', length: 256 }, true, ['encrypt', 'decrypt']);
		const iv = crypto.getRandomValues(new Uint8Array(12));
		const encryptedToken = await crypto.subtle.encrypt({ name: 'AES-GCM', iv: iv }, key, encodedToken);
		GM_setValue(
			'github_token',
			JSON.stringify({ key: await crypto.subtle.exportKey('jwk', key), iv: Array.from(iv), token: Array.from(new Uint8Array(encryptedToken)) }),
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
			url: `https://api.github.com/repos/${username}/${repo}/pulls`,
			headers: {
				Authorization: `token ${token}`,
			},
			onload: function (response) {
				const pulls = JSON.parse(response.responseText);
				const dependabotPRs = pulls.filter((pr) => pr.user.login === 'dependabot[bot]');
				let index = 0;

				function processNextPR() {
					if (index < dependabotPRs.length) {
						const pr = dependabotPRs[index];
						mergePR(pr, username, repo, token, function (error) {
							if (error) {
								console.error(`Failed to merge PR #${pr.number}:`, error);
								alert(`Failed to merge PR #${pr.number}. Please check the console for more details.`);
							}
						});
						index++;
						setTimeout(processNextPR, 2000); // 2 seconds delay between each request
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

	GM_addStyle('button { background-color: #2ea44f; color: #fff; border: none; padding: 10px; border-radius: 5px; cursor: pointer; }');
	window.onload = addButton;
})();
