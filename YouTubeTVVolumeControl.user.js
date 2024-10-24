// ==UserScript==
// @name         YouTubeTV Volume Control with Memory and Draggable UI
// @namespace    http://tampermonkey.net/
// @version      1.15
// @description  Remembers and controls volume levels on YouTube TV with keyboard shortcuts and a UI for manual input
// @author       Nick2bad4u
// @match        *://tv.youtube.com/*
// @grant        none
// @updateURL    https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/YouTubeTVVolumeControl.user.js
// @downloadURL  https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/YouTubeTVVolumeControl.user.js
// @icon         https://www.google.com/s2/favicons?sz=64&domain=tv.youtube.com
// @license      UnLicense
// ==/UserScript==

(() => {
    'use strict';

    const VOLUME_KEY = 'youtubeTVVolume';
    const DEFAULT_VOLUME = 100;

    const createVolumeUI = () => {
        const sliderContainer = document.querySelector('.ytu-player-controls.style-scope.ypcs-volume-control-slot.ypcs-control .ytu-volume-slider.style-scope.volume-button-slot');
        if (!sliderContainer) {
            console.error('Volume slider container not found, cannot create UI');
            return;
        }

        // Create input box
        const volumeInput = document.createElement('input');
        volumeInput.type = 'number';
        volumeInput.min = 0;
        volumeInput.max = 100;
        volumeInput.value = localStorage.getItem(VOLUME_KEY) || DEFAULT_VOLUME;
        volumeInput.style.width = '35px';
        volumeInput.style.height = '24px';
        volumeInput.style.marginLeft = '10px';
        volumeInput.style.marginRight = '10px';
        volumeInput.style.border = '1px solid #ccc';
        volumeInput.style.background = '#1c1c1c';
        volumeInput.style.color = '#fff';
        volumeInput.style.textAlign = 'center';
        volumeInput.style.borderRadius = '4px';
        volumeInput.style.outline = 'none';

        // Create a wrapper to position it properly
        const wrapper = document.createElement('div');
        wrapper.style.display = 'flex';
        wrapper.style.alignItems = 'center';
        wrapper.style.marginRight = '10px';

        // Insert the input box into the correct container
        wrapper.appendChild(volumeInput);
        sliderContainer.parentNode.insertBefore(wrapper, sliderContainer);

        // Prevent key events from propagating while typing
        volumeInput.addEventListener('keydown', (e) => {
            e.stopPropagation();
        });

        // Event listener for manual input changes
        volumeInput.addEventListener('input', (e) => {
            let newValue = parseFloat(e.target.value);
            if (newValue < 0) newValue = 0;
            if (newValue > 100) newValue = 100;
            setVolume(newValue);
        });

        // Function to update input when slider moves
        const slider = document.querySelector('tp-yt-paper-slider[role="slider"].ytu-volume-slider');
        const updateInput = () => {
            volumeInput.value = slider.value;
        };

        // Observe slider changes
        const observer = new MutationObserver(updateInput);
        observer.observe(slider, { attributes: true, attributeFilter: ['value'] });
    };

    const setVolume = (value) => {
        const slider = document.querySelector('tp-yt-paper-slider[role="slider"].ytu-volume-slider');
        if (slider) {
            console.log(`Setting volume to: ${value}`);
            slider.value = value;
            slider.setAttribute('value', value);
            slider.dispatchEvent(new Event('input', { bubbles: true }));
            slider.dispatchEvent(new Event('change', { bubbles: true }));
        } else {
            console.error('Volume slider not found');
        }
        localStorage.setItem(VOLUME_KEY, value);
    };

    const loadSavedVolume = () => {
        const savedVolume = localStorage.getItem(VOLUME_KEY);
        console.log(`Saved volume found: ${savedVolume}`);
        if (savedVolume) {
            setVolume(parseFloat(savedVolume));
        } else {
            console.log('No saved volume found, defaulting to 100');
            setVolume(DEFAULT_VOLUME);
        }
    };

    const tryLoadVolume = () => {
        const slider = document.querySelector('tp-yt-paper-slider[role="slider"].ytu-volume-slider');
        if (slider) {
            loadSavedVolume();
            createVolumeUI();
        } else {
            console.error('Volume slider not found, retrying in 3 seconds');
            setTimeout(tryLoadVolume, 3000);
        }
    };

    const observeSliderChanges = () => {
        const slider = document.querySelector('tp-yt-paper-slider[role="slider"].ytu-volume-slider');
        if (slider) {
            console.log('Observing the volume slider for changes');
            const observer = new MutationObserver(() => {
                const currentValue = slider.value;
                console.log(`Current volume changed to: ${currentValue}`);
                localStorage.setItem(VOLUME_KEY, currentValue);
            });
            observer.observe(slider, { attributes: true });
        } else {
            console.error('Volume slider not found during initialization');
            setTimeout(observeSliderChanges, 1000);
        }
    };

    window.addEventListener('load', () => {
        console.log('YouTube TV Volume Rememberer script with UI loaded');
        setTimeout(() => {
            tryLoadVolume();
            observeSliderChanges();
        }, 1000);
    });

    window.addEventListener('keydown', (event) => {
        const slider = document.querySelector('tp-yt-paper-slider[role="slider"].ytu-volume-slider');
        if (!slider) return;

        const isShiftPressed = event.shiftKey;

        if (isShiftPressed && event.key === 'ArrowUp') {
            const newValue = Math.min(parseFloat(slider.value) + 5, 100);
            setVolume(newValue);
        } else if (isShiftPressed && event.key === 'ArrowDown') {
            const newValue = Math.max(parseFloat(slider.value) - 5, 0);
            setVolume(newValue);
        }
    });
})();
