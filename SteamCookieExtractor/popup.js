document.addEventListener(
	'DOMContentLoaded',
	function () {
		// Fetch and display cookies
		chrome.cookies.get(
			{
				url: 'https://store.steampowered.com',
				name: 'steamLoginSecure',
			},
			function (cookie) {
				document.getElementById(
					'steamLoginSecure',
				).value = cookie
					? cookie.value
					: 'Not found';
			},
		);

		chrome.cookies.get(
			{
				url: 'https://store.steampowered.com',
				name: 'sessionid',
			},
			function (cookie) {
				document.getElementById(
					'sessionid',
				).value = cookie
					? cookie.value
					: 'Not found';
			},
		);

		// Load saved preferences
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
		const saveIndicator = document.getElementById(
			'saveIndicator',
		);

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

		function showSaveIndicator() {
			saveIndicator.style.display = 'block';
			setTimeout(() => {
				saveIndicator.style.display = 'none';
			}, 2000);
		}

		// Save preferences when checkboxes are clicked
		disableSteamCommunityCheckbox.addEventListener(
			'change',
			() => {
				chrome.storage.sync.set(
					{
						disableSteamCommunity:
							disableSteamCommunityCheckbox.checked,
					},
					showSaveIndicator,
				);
			},
		);

		disableStoreCheckbox.addEventListener(
			'change',
			() => {
				chrome.storage.sync.set(
					{
						disableStore:
							disableStoreCheckbox.checked,
					},
					showSaveIndicator,
				);
			},
		);

		disableFetchCheckbox.addEventListener(
			'change',
			() => {
				chrome.storage.sync.set(
					{
						disableFetch:
							disableFetchCheckbox.checked,
					},
					showSaveIndicator,
				);
			},
		);

		// Save preferences when fetch interval input is changed
		fetchIntervalInput.addEventListener(
			'input',
			() => {
				chrome.storage.sync.set(
					{
						fetchInterval:
							fetchIntervalInput.value,
					},
					showSaveIndicator,
				);
			},
		);
	},
);
