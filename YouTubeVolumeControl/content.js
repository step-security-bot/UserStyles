(async function () {
  'use strict';

  // Get saved volume level from Chrome storage or default to 5
  const previousVolume = (await chrome.storage.local.get('youtubeVolume')).youtubeVolume || 5;

  // Create input element for volume control
  const volumeInput = document.createElement('input');
  volumeInput.type = 'number';
  volumeInput.min = 0;
  volumeInput.max = 100;
  volumeInput.value = previousVolume;

  // Set styles for the input field
  Object.assign(volumeInput.style, {
    width: '30px',
    marginRight: '10px',
    backgroundColor: 'rgba(255, 255, 255, 0.0)',
    color: 'white',
    border: '0px solid rgba(255, 255, 255, 0.0)',
    borderRadius: '4px',
    zIndex: 9999,
    height: '24px',
    fontSize: '16px',
    padding: '0 4px',
    transition: 'border-color 0.3s, background-color 0.3s',
    outline: 'none',
    position: 'relative',
    top: '13px'
  });

  // Handle focus, blur, hover states
  volumeInput.addEventListener('focus', () => volumeInput.style.borderColor = 'rgba(255, 255, 255, 0.6)');
  volumeInput.addEventListener('blur', () => volumeInput.style.borderColor = 'rgba(255, 255, 255, 0.3)');
  volumeInput.addEventListener('mouseenter', () => volumeInput.style.backgroundColor = 'rgba(0, 0, 0, 0.8)');
  volumeInput.addEventListener('mouseleave', () => volumeInput.style.backgroundColor = 'rgba(255, 255, 255, 0.0)');
  volumeInput.addEventListener('keydown', (event) => event.stopPropagation());

  // Set volume function
  async function setVolume(volumeValue) {
    const player = document.querySelector('video');
    if (player) {
      // Validate input range
      volumeValue = Math.min(100, Math.max(0, volumeValue));
      volumeInput.value = volumeValue;
      player.volume = volumeValue / 100;

      // Save volume to Chrome storage
      await chrome.storage.local.set({ 'youtubeVolume': volumeValue });
      console.log(`Volume set to ${volumeValue} and saved.`);

      // Sync YouTube's volume slider if available
      const volumeSlider = document.querySelector('.ytp-volume-slider-handle');
      if (volumeSlider) volumeSlider.style.left = `${volumeValue}%`;
    }
  }

  // Update input field on YouTube player volume change
  async function updateVolumeInput() {
    const player = document.querySelector('video');
    if (player) {
      const currentVolume = Math.round(player.volume * 100);
      volumeInput.value = currentVolume;
      await chrome.storage.local.set({ 'youtubeVolume': currentVolume });
      if (player.muted) volumeInput.value = 0;
    }
  }

  // Handle mute changes
  function handleMuteChange() {
    const player = document.querySelector('video');
    if (player) {
      volumeInput.value = player.muted ? 0 : previousVolume;
      player.volume = previousVolume / 100;
    }
  }

  // Inject input element into YouTube's control bar
  function injectVolumeControl() {
    const volumeSliderPanel = document.querySelector('.ytp-volume-panel');
    if (volumeSliderPanel) {
      volumeSliderPanel.parentNode.insertBefore(volumeInput, volumeSliderPanel);
      setVolume(previousVolume); // Set initial volume
      const player = document.querySelector('video');
      if (player) {
        player.addEventListener('volumechange', updateVolumeInput);
        player.addEventListener('mute', handleMuteChange);
        player.addEventListener('unmute', handleMuteChange);
      }
    } else {
      setTimeout(injectVolumeControl, 500); // Retry if not yet available
    }
  }

  // Inject volume control on page load
  injectVolumeControl();

  // Event listener for manual volume change in input
  volumeInput.addEventListener('input', () => setVolume(volumeInput.value));
})();
