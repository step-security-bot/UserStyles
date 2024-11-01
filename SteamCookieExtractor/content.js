(function() {
    'use strict';

    chrome.storage.sync.get(['disableSteamCommunity', 'disableStore'], (result) => {
        const url = window.location.href;
        if((result.disableSteamCommunity && url.includes('steamcommunity.com')) ||
            (result.disableStore && url.includes('store.steampowered.com'))) {
            return; // Do not inject the UI
        }

        // Create the button
        let button = document.createElement('button');
        button.textContent = 'Show Steam Cookies';
        button.style.position = 'fixed';
        button.style.bottom = '10px';
        button.style.right = '10px';
        button.style.backgroundColor = '#333';
        button.style.color = '#fff';
        button.style.padding = '10px';
        button.style.border = 'none';
        button.style.borderRadius = '5px';
        button.style.cursor = 'pointer';
        button.style.zIndex = '10000';

        // Add click event to open the popup
        button.addEventListener('click', () => {
            chrome.runtime.sendMessage({
                action: 'openPopup'
            });
        });

        // Append the button to the body
        document.body.appendChild(button);
    });
})();
