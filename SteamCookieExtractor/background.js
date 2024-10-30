chrome.runtime.onInstalled.addListener(() => {
  console.log('Extension installed');
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

  // Fetch cookies when the extension is installed or updated
  fetchSteamCookies();
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

// Function to fetch Steam cookies
function fetchSteamCookies() {
  chrome.cookies.getAll({ domain: 'steampowered.com' }, (cookies) => {
    const sessionidCookie = cookies.find(cookie => cookie.name === 'sessionid');
    if (sessionidCookie) {
      console.log('SessionID:', sessionidCookie.value);
    } else {
      console.log('SessionID cookie not found');
    }
  });
}