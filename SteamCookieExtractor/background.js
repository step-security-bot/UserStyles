chrome.runtime.onInstalled.addListener(() => {
  console.log('Extension installed');
  fetchSteamCookies();  // Fetch cookies immediately upon installation
  setFetchInterval();   // Set up the interval for periodic fetching
});

// Fetch cookies when the browser restarts
chrome.runtime.onStartup.addListener(() => {
  console.log('Browser restarted');
  fetchSteamCookies();  // Fetch cookies at startup
  setFetchInterval();   // Set up the interval for periodic fetching
});

chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  console.log('Message received:', request);
  if (request.action === 'openPopup') {
    chrome.windows.create({
      url: chrome.runtime.getURL('popup.html'),
      type: 'popup',
      width: 500,
      height: 300
    }, (window) => {
      console.log('Popup window created:', window);
    });
  }
});

function fetchSteamCookies() {
  chrome.tabs.create({ url: 'https://store.steampowered.com', active: false }, (tab) => {
    const targetTabId = tab.id;
    console.log(`Created tab with ID: ${targetTabId}`);

    function handleTabUpdate(updatedTabId, info, updatedTab) {
      if (updatedTabId === targetTabId && info.status === 'complete' && updatedTab.url.includes('store.steampowered.com')) {
        console.log('Steam store loaded, fetching cookies...');
        
        chrome.cookies.getAll({ domain: 'steampowered.com' }, (cookies) => {
          const sessionidCookie = cookies.find(cookie => cookie.name === 'sessionid');
          if (sessionidCookie) {
            console.log('SessionID:', sessionidCookie.value);
          } else {
            console.log('SessionID cookie not found');
          }

          // Remove the listener and close the tab once done
          chrome.tabs.onUpdated.removeListener(handleTabUpdate);
          chrome.tabs.remove(targetTabId);
        });
      }
    }

    // Add the listener temporarily
    chrome.tabs.onUpdated.addListener(handleTabUpdate);
  });
}

// Set a 6-hour interval for fetching cookies
function setFetchInterval() {
  const sixHoursInMilliseconds = 6 * 60 * 60 * 1000;
  setInterval(fetchSteamCookies, sixHoursInMilliseconds);
}
