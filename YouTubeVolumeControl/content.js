// Wait for the YouTube player and controls to load
const playerReady = setInterval(() => {
  const videoPlayer = document.querySelector("video");
  const leftControls = document.querySelector(".ytp-left-controls");
  const volumeSliderHandle = document.querySelector(
    ".ytp-volume-slider-handle",
  );
  const volumePanel = document.querySelector(".ytp-volume-panel");

  if (videoPlayer && leftControls && volumeSliderHandle) {
    clearInterval(playerReady);

    // Retrieve the saved volume level from YouTube's localStorage or sessionStorage key "yt-player-volume"
    let ytVolumeData =
      localStorage.getItem("yt-player-volume") ||
      sessionStorage.getItem("yt-player-volume");
    let savedVolume = videoPlayer.volume;
    let savedMuted = videoPlayer.muted;
    let expiration = Date.now() + 2592000000; // Default expiration in 30 days
    let creation = Date.now();

    if (ytVolumeData) {
      try {
        ytVolumeData = JSON.parse(ytVolumeData);
        const data = JSON.parse(ytVolumeData.data);
        savedVolume = data.volume / 100; // YouTube stores volume from 0 to 100
        savedMuted = data.muted;
        expiration = ytVolumeData.expiration || expiration;
        creation = ytVolumeData.creation || creation;
      } catch (e) {
        console.error("Failed to parse yt-player-volume:", e);
      }
    }

    // Ensure savedVolume is within [0, 1] range
    videoPlayer.volume = Math.max(0, Math.min(1, savedVolume));
    videoPlayer.muted = savedMuted;

    // Update the slider handle position
    const updateSliderHandle = (volume) => {
      volumeSliderHandle.style.left = `${volume * 100}%`;
    };
    updateSliderHandle(videoPlayer.volume);

    // Set the aria-valuenow attribute on the volume panel
    if (volumePanel) {
      volumePanel.setAttribute("aria-valuenow", videoPlayer.volume * 100);
    }

    // Create input element for volume control
    const volumeInput = document.createElement("input");
    volumeInput.type = "number";
    volumeInput.min = 0;
    volumeInput.max = 100;
    volumeInput.value = videoPlayer.muted
      ? 0
      : Math.round(videoPlayer.volume * 100);

    // Style the input field
    Object.assign(volumeInput.style, {
      width: "40px",
      marginLeft: "10px",
      backgroundColor: "rgba(255, 255, 255, 0.0)",
      color: "white",
      border: "0px solid rgba(255, 255, 255, 0.0)",
      borderRadius: "4px",
      zIndex: 9999,
      height: "24px",
      fontSize: "16px",
      padding: "0 4px",
      transition: "border-color 0.3s, background-color 0.3s",
      outline: "none",
      position: "relative",
      top: "13px",
    });

    // Prevent hotkeys from interfering with the input
    volumeInput.addEventListener("keydown", (e) => e.stopPropagation());

    // Input focus and hover styling
    volumeInput.addEventListener(
      "focus",
      () => (volumeInput.style.borderColor = "rgba(255, 255, 255, 0.6)"),
    );
    volumeInput.addEventListener(
      "blur",
      () => (volumeInput.style.borderColor = "rgba(255, 255, 255, 0.3)"),
    );
    volumeInput.addEventListener(
      "mouseenter",
      () => (volumeInput.style.backgroundColor = "rgba(0, 0, 0, 0.8)"),
    );
    volumeInput.addEventListener(
      "mouseleave",
      () => (volumeInput.style.backgroundColor = "rgba(255, 255, 255, 0.0)"),
    );

    // Handle volume change from input
    let lastSetVolume = videoPlayer.volume;
    volumeInput.addEventListener("input", () => {
      let volume = parseInt(volumeInput.value, 10);
      volume = isNaN(volume) ? 100 : Math.max(0, Math.min(100, volume)); // Clamp between 0 and 100

      videoPlayer.volume = volume / 100; // Convert to [0, 1] range
      videoPlayer.muted = volume === 0;
      lastSetVolume = videoPlayer.volume;

      // Update the slider handle position
      updateSliderHandle(videoPlayer.volume);

      // Save the new volume to localStorage and sessionStorage
      const ytVolumeObject = {
        data: JSON.stringify({
          volume: volume, // Volume from 0 to 100
          muted: videoPlayer.muted,
        }),
        expiration: Date.now() + 2592000000, // Expires in 30 days
        creation: Date.now(),
      };
      const ytVolumeString = JSON.stringify(ytVolumeObject);
      localStorage.setItem("yt-player-volume", ytVolumeString);
      sessionStorage.setItem("yt-player-volume", ytVolumeString);
    });

    // Update input value when volume changes from other controls
    videoPlayer.addEventListener("volumechange", () => {
      if (!videoPlayer.muted) lastSetVolume = videoPlayer.volume;
      volumeInput.value = videoPlayer.muted
        ? 0
        : Math.round(videoPlayer.volume * 100);

      // Update the slider handle position
      updateSliderHandle(videoPlayer.volume);

      // Save the volume to localStorage and sessionStorage
      const volumePercent = Math.round(videoPlayer.volume * 100);
      const ytVolumeObject = {
        data: JSON.stringify({
          volume: volumePercent,
          muted: videoPlayer.muted,
        }),
        expiration: Date.now() + 2592000000,
        creation: Date.now(),
      };
      const ytVolumeString = JSON.stringify(ytVolumeObject);
      localStorage.setItem("yt-player-volume", ytVolumeString);
      sessionStorage.setItem("yt-player-volume", ytVolumeString);
    });

    // Observe changes to the muted property
    const observer = new MutationObserver(() => {
      if (!videoPlayer.muted) {
        videoPlayer.volume = lastSetVolume;
        volumeInput.value = Math.round(videoPlayer.volume * 100);
        updateSliderHandle(lastSetVolume);
      }
    });
    observer.observe(videoPlayer, {
      attributes: true,
      attributeFilter: ["muted"],
    });

    // Insert the input into the left controls
    leftControls.appendChild(volumeInput);
  } else {
    console.log("Elements not found:", {
      videoPlayer: !!videoPlayer,
      leftControls: !!leftControls,
      volumeSliderHandle: !!volumeSliderHandle,
      volumePanel: !!volumePanel,
    });
  }
}, 500);
