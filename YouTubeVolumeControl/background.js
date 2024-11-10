chrome.runtime.onInstalled.addListener(() => {
  chrome.storage.sync.set(
    {
      youtubeVolume: 5,
    },
    () => {
      console.log('Default volume set to 5');
    }
  );
});

// Function to get value
function getValue(key, callback) {
  chrome.storage.sync.get(key, (result) => {
    callback(result[key]);
  });
}

// Function to set value
function setValue(key, value) {
  chrome.storage.sync.set({
    [key]: value,
  });
}
