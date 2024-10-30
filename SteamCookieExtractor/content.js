(function() {
  'use strict';

  console.log('Content script started');

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

  console.log('Button created');

  // Add click event to open the popup
  button.addEventListener('click', () => {
    console.log('Button clicked');
    chrome.runtime.sendMessage({ action: 'openPopup' });
  });

  // Append the button to the body
  document.body.appendChild(button);
  console.log('Button appended to the body');
})();