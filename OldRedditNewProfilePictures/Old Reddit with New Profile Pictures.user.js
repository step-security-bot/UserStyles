// ==UserScript==
// @name         Old Reddit with New Reddit Profile Pictures
// @namespace    http://tampermonkey.net/
// @version      1.13
// @description  Injects new Reddit profile pictures into Old Reddit and reddit-stream.com next to the username
// @author       Nick2bad4u
// @match        https://*.reddit.com/*
// @match        https://www.*.reddit.com/*
// @match        https://reddit-stream.com/*
// @grant        GM_xmlhttpRequest
// @grant        GM_setValue
// @grant        GM_getValue
// @connect      reddit.com
// @updateURL    https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/OldRedditNewProfilePictures/Old%20Reddit%20with%20New%20Profile%20Pictures.user.js
// @downloadURL  https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/OldRedditNewProfilePictures/Old%20Reddit%20with%20New%20Profile%20Pictures.user.js
// ==/UserScript==

(function() {
    'use strict';
    console.log('Script loaded');

    let profilePictureCache = GM_getValue('profilePictureCache', {});
    let cacheTimestamps = GM_getValue('cacheTimestamps', {});
    const CACHE_DURATION = 7 * 24 * 60 * 60 * 1000; // 7 days in milliseconds
    const processedUsernames = new Set();

    function flushOldCache() {
        const now = Date.now();
        for (const username in cacheTimestamps) {
            if (now - cacheTimestamps[username] > CACHE_DURATION) {
                delete profilePictureCache[username];
                delete cacheTimestamps[username];
            }
        }
        GM_setValue('profilePictureCache', profilePictureCache);
        GM_setValue('cacheTimestamps', cacheTimestamps);
        console.log('Old cache entries flushed');
    }

    flushOldCache();
    console.log('Cache loaded:', profilePictureCache);

    async function fetchProfilePictures(usernames) {
        const uncachedUsernames = usernames.filter(username => !profilePictureCache[username]);
        if (uncachedUsernames.length === 0) {
            console.log('All usernames are cached');
            return usernames.map(username => profilePictureCache[username]);
        }
        console.log(`Fetching profile pictures for: ${uncachedUsernames.join(', ')}`);
        const requests = uncachedUsernames.map(username => new Promise((resolve, reject) => {
            GM_xmlhttpRequest({
                method: 'GET',
                url: `https://www.reddit.com/user/${username}/about.json`,
                onload: (response) => {
                    const data = JSON.parse(response.responseText);
                    if (data.data.icon_img) {
                        const profilePictureUrl = data.data.icon_img.split('?')[0];
                        profilePictureCache[username] = profilePictureUrl;
                        cacheTimestamps[username] = Date.now();
                        GM_setValue('profilePictureCache', profilePictureCache);
                        GM_setValue('cacheTimestamps', cacheTimestamps);
                        console.log(`Fetched profile picture: ${username}`);
                        resolve(profilePictureUrl);
                    } else {
                        console.warn(`No profile picture found for: ${username}`);
                        resolve(null);
                    }
                },
                onerror: (error) => {
                    console.error(`Error fetching profile picture: ${username}`, error);
                    reject(error);
                }
            });
        }));
        await Promise.all(requests);
        return usernames.map(username => profilePictureCache[username]);
    }

    async function injectProfilePictures(comments) {
        console.log(`Comments found: ${comments.length}`);
        const usernames = Array.from(comments).map(comment => comment.textContent.trim());
        const firstBatch = usernames.slice(0, 100);
        const remainingBatch = usernames.slice(100);

        const profilePictureUrls = await fetchProfilePictures(firstBatch);
        comments.forEach((comment, index) => {
            if (index < 100) {
                const username = firstBatch[index];
                const profilePictureUrl = profilePictureUrls[index];
                if (profilePictureUrl && !comment.previousElementSibling?.classList.contains('profile-picture') && !processedUsernames.has(username)) {
                    console.log(`Injecting profile picture: ${username}`);
                    const img = document.createElement('img');
                    img.src = profilePictureUrl;
                    img.classList.add('profile-picture');
                    img.onerror = () => { img.style.display = 'none'; };
                    img.addEventListener('click', () => { window.open(profilePictureUrl, '_blank'); });
                    comment.insertAdjacentElement('beforebegin', img);
                    const enlargedImg = document.createElement('img');
                    enlargedImg.src = profilePictureUrl;
                    enlargedImg.classList.add('enlarged-profile-picture');
                    document.body.appendChild(enlargedImg);
                    img.addEventListener('mouseover', () => {
                        enlargedImg.style.display = 'block';
                        const rect = img.getBoundingClientRect();
                        enlargedImg.style.top = `${rect.top + window.scrollY + 20}px`;
                        enlargedImg.style.left = `${rect.left + window.scrollX + 20}px`;
                    });
                    img.addEventListener('mouseout', () => { enlargedImg.style.display = 'none'; });
                    processedUsernames.add(username);
                }
            }
        });

        if (remainingBatch.length > 0) {
            const remainingProfilePictureUrls = await fetchProfilePictures(remainingBatch);
            comments.forEach((comment, index) => {
                if (index >= 100) {
                    const username = remainingBatch[index - 100];
                    const profilePictureUrl = remainingProfilePictureUrls[index - 100];
                    if (profilePictureUrl && !comment.previousElementSibling?.classList.contains('profile-picture') && !processedUsernames.has(username)) {
                        console.log(`Injecting profile picture: ${username}`);
                        const img = document.createElement('img');
                        img.src = profilePictureUrl;
                        img.classList.add('profile-picture');
                        img.onerror = () => { img.style.display = 'none'; };
                        img.addEventListener('click', () => { window.open(profilePictureUrl, '_blank'); });
                        comment.insertAdjacentElement('beforebegin', img);
                        const enlargedImg = document.createElement('img');
                        enlargedImg.src = profilePictureUrl;
                        enlargedImg.classList.add('enlarged-profile-picture');
                        document.body.appendChild(enlargedImg);
                        img.addEventListener('mouseover', () => {
                            enlargedImg.style.display = 'block';
                            const rect = img.getBoundingClientRect();
                            enlargedImg.style.top = `${rect.top + window.scrollY + 20}px`;
                            enlargedImg.style.left = `${rect.left + window.scrollX + 20}px`;
                        });
                        img.addEventListener('mouseout', () => { enlargedImg.style.display = 'none'; });
                        processedUsernames.add(username);
                    }
                }
            });
        }

        console.log('Profile pictures injected');
    }

    function setupObserver() {
        let timeout;
        const observer = new MutationObserver(() => {
            if (timeout) clearTimeout(timeout);
            timeout = setTimeout(() => {
                const comments = document.querySelectorAll('.author, .c-username');
                if (comments.length > 0) {
                    console.log('New comments detected');
                    injectProfilePictures(comments);
                }
            }, 300); // Adding a delay to prevent continuous execution
        });
        observer.observe(document.body, { childList: true, subtree: true });
        console.log('Observer initialized');
    }

    window.addEventListener('load', () => {
        console.log('Page loaded');
        setupObserver();
    });

    const style = document.createElement('style');
    style.textContent = `
        .profile-picture {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            margin-right: 5px;
            transition: transform 0.2s ease-in-out;
            position: relative;
            z-index: 1;
            cursor: pointer;
        }
        .enlarged-profile-picture {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            position: absolute;
            display: none;
            z-index: 1000;
            pointer-events: none;
            outline: 2px solid #000;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 1);
            background-color: rgba(0, 0, 0, 1);
        }
        .author, .c-username {
            display: inline-flex;
            align-items: center;
        }
    `;
    document.head.appendChild(style);
})();
