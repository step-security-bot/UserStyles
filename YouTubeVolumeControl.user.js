// ==UserScript==
// @name         YouTube Volume Control with Memory and Draggable UI
// @namespace    http://tampermonkey.net/
// @version      2.6
// @description  Set YouTube volume manually on a scale of 1-100, remember last set volume, and inject the UI to the left of the volume slider on the video player. Syncs the slider, disables invalid inputs, and adds debugging.
// @author       Nick2bad4u
// @match        *://www.youtube.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=youtube.com
// @grant        none
// @updateURL    https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/YouTubeVolumeControl.user.js
// @downloadURL  https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/YouTubeVolumeControl.user.js
// @license      UnLicense
// ==/UserScript==

(function() {
    'use strict';

    // Variable to hold the previous volume level
    let previousVolume = localStorage.getItem('youtubeVolume') || 50;

    // Create input element for volume control
    const volumeInput = document.createElement('input');
    volumeInput.type = 'number';
    volumeInput.min = 0;
    volumeInput.max = 100;
    volumeInput.value = previousVolume;

    // Set input field styles to resemble YouTube's UI
    volumeInput.style.width = '30px';
    volumeInput.style.marginRight = '10px';
    volumeInput.style.backgroundColor = 'rgba(255, 255, 255, 0.0)';
    volumeInput.style.color = 'white'; // Change text color to white
    volumeInput.style.border = '0px solid rgba(255, 255, 255, 0.0)';
    volumeInput.style.borderRadius = '4px';
    volumeInput.style.zIndex = 9999;
    volumeInput.style.height = '24px';
    volumeInput.style.fontSize = '16px';
    volumeInput.style.padding = '0 4px';
    volumeInput.style.transition = 'border-color 0.3s, background-color 0.3s'; // Added background color transition
    volumeInput.style.outline = 'none';
    volumeInput.style.position = 'relative';
    volumeInput.style.top = '13px'; // Adjust to lower the input 13 pixels

    // Change border color on focus
    volumeInput.addEventListener('focus', () => {
        volumeInput.style.borderColor = 'rgba(255, 255, 255, 0.6)';
    });

    volumeInput.addEventListener('blur', () => {
        volumeInput.style.borderColor = 'rgba(255, 255, 255, 0.3)';
    });

    // Change background color on hover
    volumeInput.addEventListener('mouseenter', () => {
        volumeInput.style.backgroundColor = 'rgba(0, 0, 0, 0.8)'; // Dark background on hover
    });

    volumeInput.addEventListener('mouseleave', () => {
        volumeInput.style.backgroundColor = 'rgba(255, 255, 255, 0.0)'; // Restore background when not hovered
    });

    // Prevent YouTube hotkeys when typing in the input
    volumeInput.addEventListener('keydown', function(event) {
        event.stopPropagation();
        console.log('Keydown event in volume input, stopping propagation.');
    });

    // Function to set the volume based on input value
    function setVolume() {
        const player = document.querySelector('video');
        if (player) {
            let volumeValue = volumeInput.value;

            // Validate input (must be between 0 and 100)
            if (volumeValue < 0) volumeValue = 0;
            if (volumeValue > 100) volumeValue = 100;
            volumeInput.value = volumeValue;

            // Set the player volume and save to local storage
            player.volume = volumeValue / 100;
            localStorage.setItem('youtubeVolume', volumeValue);
            console.log(`Volume set to ${volumeValue} and saved to local storage.`);

            // Sync YouTube's volume slider UI
            const volumeSlider = document.querySelector('.ytp-volume-slider-handle');
            if (volumeSlider) {
                volumeSlider.style.left = `${volumeValue}%`;
                console.log('YouTube volume slider updated.');
            }
        }
    }

    // Event listener for input change (manually changing the volume in the input box)
    volumeInput.addEventListener('input', setVolume);

    // Function to update the input field when YouTube's player volume is changed
    function updateVolumeInput() {
        const player = document.querySelector('video');
        if (player) {
            const currentVolume = Math.round(player.volume * 100);
            volumeInput.value = currentVolume;
            localStorage.setItem('youtubeVolume', currentVolume);
            console.log(`Volume input updated to ${currentVolume} from video player.`);

            // Show 0 if the video is muted
            if (player.muted) {
                volumeInput.value = 0;
            }
        }
    }

    // Function to handle mute changes
    function handleMuteChange() {
        const player = document.querySelector('video');
        if (player) {
            if (player.muted) {
                volumeInput.value = 0; // Show 0 when muted
            } else {
                volumeInput.value = previousVolume; // Restore previous volume when unmuted
                player.volume = previousVolume / 100; // Set the player volume back to previous
            }
            console.log(`Mute state changed: muted = ${player.muted}`);
        }
    }

    // Inject the input box into YouTube's control bar
    function injectVolumeControl() {
        const volumeSliderPanel = document.querySelector('.ytp-volume-panel');
        if (volumeSliderPanel) {
            volumeSliderPanel.parentNode.insertBefore(volumeInput, volumeSliderPanel);
            setVolume(); // Set initial volume
            const player = document.querySelector('video');
            if (player) {
                player.addEventListener('volumechange', updateVolumeInput);
                player.addEventListener('mute', handleMuteChange);
                player.addEventListener('unmute', handleMuteChange);
                console.log('Volume input injected and event listeners attached.');
            }
        } else {
            console.log('Volume panel not found, retrying...');
            setTimeout(injectVolumeControl, 500);
        }
    }

    // Inject the volume control when the page is ready
    injectVolumeControl();

})();
