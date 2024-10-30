chrome.runtime.onInstalled.addListener(() => {
  chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
    if (changeInfo.status === 'complete' && tab.url) {
      if (tab.url.includes('steamcommunity.com') || tab.url.includes('store.steampowered.com')) {
        chrome.scripting.executeScript({
          target: { tabId: tabId },
          files: ['content.js']
        });
      }
    }
  });
});

chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'openPopup') {
    chrome.windows.create({
      url: chrome.runtime.getURL('popup.html'),
      type: 'popup',
      width: 500,
      height: 300
    });
  }
});
