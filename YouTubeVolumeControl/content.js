// Wait for the YouTube player and controls to load
const playerReady = setInterval(() => {
  const videoPlayer = document.querySelector('video');
  const leftControls = document.querySelector('.ytp-left-controls');
  const volumeSlider = document.querySelector('.ytp-volume-panel .ytp-volume-slider');

  if (videoPlayer && leftControls && volumeSlider) {
    clearInterval(playerReady);

    // Retrieve the saved volume level from localStorage
    let savedVolume = localStorage.getItem('youtubeVolume');
    savedVolume = savedVolume !== null ? parseFloat(savedVolume) : videoPlayer.volume;

    // Ensure savedVolume is within [0, 1] range for the video player's volume property
    videoPlayer.volume = Math.max(0, Math.min(1, savedVolume));
    videoPlayer.muted = videoPlayer.volume === 0;

    // Update the slider to reflect the saved volume
    volumeSlider.style.setProperty('--ytp-volume-slider-value', videoPlayer.volume * 100);

    // Create input element for volume control
    const volumeInput = document.createElement('input');
    volumeInput.type = 'number';
    volumeInput.min = 0;
    volumeInput.max = 100;
    volumeInput.value = videoPlayer.muted ? 0 : Math.round(videoPlayer.volume * 100);

    // Style the input field
    Object.assign(volumeInput.style, {
      width: '40px',
      marginLeft: '10px',
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

    // Prevent hotkeys from interfering with the input
    volumeInput.addEventListener('keydown', (e) => e.stopPropagation());

    // Input focus and hover styling
    volumeInput.addEventListener('focus', () => volumeInput.style.borderColor = 'rgba(255, 255, 255, 0.6)');
    volumeInput.addEventListener('blur', () => volumeInput.style.borderColor = 'rgba(255, 255, 255, 0.3)');
    volumeInput.addEventListener('mouseenter', () => volumeInput.style.backgroundColor = 'rgba(0, 0, 0, 0.8)');
    volumeInput.addEventListener('mouseleave', () => volumeInput.style.backgroundColor = 'rgba(255, 255, 255, 0.0)');

    // Handle volume change from input
    let lastSetVolume = savedVolume;
    volumeInput.addEventListener('input', () => {
      let volume = parseInt(volumeInput.value, 10);
      volume = isNaN(volume) ? 100 : Math.max(0, Math.min(100, volume)); // Clamp between 0 and 100

      videoPlayer.volume = volume / 100; // Convert to [0, 1] range
      videoPlayer.muted = volume === 0;
      lastSetVolume = videoPlayer.volume;

      // Update the YouTube slider directly
      volumeSlider.style.setProperty('--ytp-volume-slider-value', volume);

      // Save the new volume to localStorage
      localStorage.setItem('youtubeVolume', lastSetVolume);
    });

    // Update input value when volume changes from other controls
    videoPlayer.addEventListener('volumechange', () => {
      if (!videoPlayer.muted) lastSetVolume = videoPlayer.volume;
      volumeInput.value = videoPlayer.muted ? 0 : Math.round(videoPlayer.volume * 100);

      // Save the volume to localStorage when it changes
      localStorage.setItem('youtubeVolume', videoPlayer.volume);
    });

    // Listen for changes to the muted property and restore volume on unmute
    const observer = new MutationObserver(() => {
      if (!videoPlayer.muted) {
        videoPlayer.volume = lastSetVolume;
        volumeInput.value = Math.round(videoPlayer.volume * 100);
        volumeSlider.style.setProperty('--ytp-volume-slider-value', lastSetVolume * 100);
      }
    });
    observer.observe(videoPlayer, { attributes: true, attributeFilter: ['muted'] });

    // Insert the input into the left controls
    leftControls.appendChild(volumeInput);
  }
}, 500);
