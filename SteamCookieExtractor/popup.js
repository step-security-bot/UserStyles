document.addEventListener('DOMContentLoaded', function() {
  chrome.cookies.get({ url: 'https://store.steampowered.com', name: 'steamLoginSecure' }, function(cookie) {
    if (cookie) {
      document.getElementById('steamLoginSecure').value = cookie.value;
    } else {
      document.getElementById('steamLoginSecure').value = 'Not found';
    }
  });

  chrome.cookies.get({ url: 'https://store.steampowered.com', name: 'sessionid' }, function(cookie) {
    if (cookie) {
      document.getElementById('sessionid').value = cookie.value;
    } else {
      document.getElementById('sessionid').value = 'Not found';
    }
  });
});

/* chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'openPopup') {
    window.open(chrome.runtime.getURL('popup.html'), '_blank', 'width=400,height=300');
  }
});
 */