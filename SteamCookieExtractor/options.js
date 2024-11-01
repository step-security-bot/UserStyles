document.addEventListener('DOMContentLoaded', () => {
  const disableSteamCommunityCheckbox = document.getElementById('disableSteamCommunity');
  const disableStoreCheckbox = document.getElementById('disableStore');
  const disableFetchCheckbox = document.getElementById('disableFetch');
  const fetchIntervalInput = document.getElementById('fetchInterval');
  const saveButton = document.getElementById('saveButton');

  // Load saved preferences
  chrome.storage.sync.get(['disableSteamCommunity', 'disableStore', 'disableFetch', 'fetchInterval'], (result) => {
    disableSteamCommunityCheckbox.checked = result.disableSteamCommunity || false;
    disableStoreCheckbox.checked = result.disableStore || false;
    disableFetchCheckbox.checked = result.disableFetch || false;
    fetchIntervalInput.value = result.fetchInterval || 6;
  });

  // Save preferences on button click
  saveButton.addEventListener('click', () => {
    chrome.storage.sync.set({
      disableSteamCommunity: disableSteamCommunityCheckbox.checked,
      disableStore: disableStoreCheckbox.checked,
      disableFetch: disableFetchCheckbox.checked,
      fetchInterval: fetchIntervalInput.value
    }, () => {
      alert('Options saved.');
    });
  });
});