document.addEventListener(
	'DOMContentLoaded',
	() => {
		const disableSteamCommunityCheckbox =
			document.getElementById(
				'disableSteamCommunity',
			);
		const disableStoreCheckbox =
			document.getElementById('disableStore');
		const disableFetchCheckbox =
			document.getElementById('disableFetch');
		const fetchIntervalInput =
			document.getElementById('fetchInterval');

		// Load saved preferences
		chrome.storage.sync.get(
			[
				'disableSteamCommunity',
				'disableStore',
				'disableFetch',
				'fetchInterval',
			],
			(result) => {
				disableSteamCommunityCheckbox.checked =
					result.disableSteamCommunity || false;
				disableStoreCheckbox.checked =
					result.disableStore || false;
				disableFetchCheckbox.checked =
					result.disableFetch || false;
				fetchIntervalInput.value =
					result.fetchInterval || 6;
			},
		);

		// Save preferences when checkboxes are clicked
		disableSteamCommunityCheckbox.addEventListener(
			'change',
			() => {
				chrome.storage.sync.set({
					disableSteamCommunity:
						disableSteamCommunityCheckbox.checked,
				});
			},
		);

		disableStoreCheckbox.addEventListener(
			'change',
			() => {
				chrome.storage.sync.set({
					disableStore:
						disableStoreCheckbox.checked,
				});
			},
		);

		disableFetchCheckbox.addEventListener(
			'change',
			() => {
				chrome.storage.sync.set({
					disableFetch:
						disableFetchCheckbox.checked,
				});
			},
		);

		// Save preferences when fetch interval input is changed
		fetchIntervalInput.addEventListener(
			'input',
			() => {
				chrome.storage.sync.set({
					fetchInterval: fetchIntervalInput.value,
				});
			},
		);
	},
);
