/* eslint-disable no-undef */

// Event listener for extension installation
chrome.runtime.onInstalled.addListener(() => {
	console.log('Extension installed');
	initializeFetch();
});

// Event listener for browser startup
chrome.runtime.onStartup.addListener(() => {
	console.log('Browser restarted');
	initializeFetch();
});

// Initialize fetch settings
async function initializeFetch() {
	try {
		const result = await getChromeStorage(['disableFetch', 'fetchInterval']);
		if (!result.disableFetch) {
			await fetchSteamCookies(); // Fetch cookies immediately upon installation/startup
			setFetchInterval(result.fetchInterval || 60); // Set up the interval for periodic fetching
		}
	} catch (error) {
		console.error('Error initializing fetch:', error);
	}
}

// Event listener for messages
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
	console.log('Message received:', request);
	if (request.action === 'openPopup') {
		openPopupWindow();
	}
	sendResponse({ status: 'received' });
});

// Function to get data from Chrome storage
function getChromeStorage(keys) {
	return new Promise((resolve, reject) => {
		chrome.storage.sync.get(keys, (result) => {
			if (chrome.runtime.lastError) {
				reject(chrome.runtime.lastError);
			} else {
				resolve(result);
			}
		});
	});
}

// Function to open a popup window
function openPopupWindow() {
	chrome.windows.create(
		{
			url: chrome.runtime.getURL('popup.html'),
			type: 'popup',
			width: 500,
			height: 600,
		},
		(window) => {
			console.log('Popup window created:', window);
			// Refresh cookies when the popup is opened
			fetchSteamCookies();
		},
	);
}

// Function to fetch Steam cookies from both the store and community pages
async function fetchSteamCookies() {
	const tabsToClose = [];
	try {
		const storeTab = await createTab('https://store.steampowered.com');
		tabsToClose.push(storeTab.id);
		await waitForTabLoad(storeTab.id, 'store.steampowered.com');
		const storeCookies = await getCookies('store.steampowered.com');

		const communityTab = await createTab(
			'https://steamcommunity.com/id/TyppiLol',
		);
		tabsToClose.push(communityTab.id);
		await waitForTabLoad(communityTab.id, 'steamcommunity.com');
		const communityCookies = await getCookies('steamcommunity.com');

		const cookies = {
			store: storeCookies,
			community: communityCookies,
			lastFetched: new Date().toISOString(),
		};

		chrome.storage.local.set({ steamCookies: cookies }, () => {
			if (chrome.runtime.lastError) {
				console.error('Error setting cookies:', chrome.runtime.lastError);
			} else {
				console.log('Cookies set:', cookies);
				showNotification(
					'Cookies refreshed',
					'Steam cookies have been successfully refreshed.',
				);
				chrome.runtime.sendMessage({ action: 'updateCookies', cookies });
			}
		});
	} catch (error) {
		console.error('Error fetching Steam cookies:', error);
	} finally {
		for (const tabId of tabsToClose) {
			await closeTab(tabId);
		}
	}
}

// Function to create a new tab
function createTab(url) {
	return new Promise((resolve, reject) => {
		chrome.tabs.create({ url, active: false }, (tab) => {
			if (chrome.runtime.lastError) {
				reject(chrome.runtime.lastError);
			} else {
				resolve(tab);
			}
		});
	});
}

// Function to wait for a tab to load completely
function waitForTabLoad(tabId, urlFragment) {
	return new Promise((resolve) => {
		function handleTabUpdate(updatedTabId, info, updatedTab) {
			if (
				updatedTabId === tabId &&
				info.status === 'complete' &&
				updatedTab.url.includes(urlFragment)
			) {
				chrome.tabs.onUpdated.removeListener(handleTabUpdate);
				resolve();
			}
		}

		chrome.tabs.onUpdated.addListener(handleTabUpdate);
	});
}

// Function to get cookies for a specific domain
function getCookies(domain) {
	return new Promise((resolve, reject) => {
		chrome.cookies.getAll({ domain }, (cookies) => {
			if (chrome.runtime.lastError) {
				reject(chrome.runtime.lastError);
			} else {
				resolve(cookies);
			}
		});
	});
}

// Function to close a tab
function closeTab(tabId) {
	return new Promise((resolve, reject) => {
		chrome.tabs.remove(tabId, () => {
			if (chrome.runtime.lastError) {
				reject(chrome.runtime.lastError);
			} else {
				resolve();
			}
		});
	});
}

// Function to set the fetch interval
function setFetchInterval(minutes) {
	const interval = minutes * 60 * 1000;
	setInterval(async () => {
		const result = await getChromeStorage(['disableFetch']);
		if (!result.disableFetch) {
			await fetchSteamCookies();
		}
	}, interval);
}

// Function to show notifications
function showNotification(title, message) {
	chrome.storage.sync.get('enableNotifications', (result) => {
		if (result.enableNotifications) {
			chrome.notifications.create({
				type: 'basic',
				iconUrl: 'icons/icon128.png',
				title: title,
				message: message,
			});
		}
	});
}
