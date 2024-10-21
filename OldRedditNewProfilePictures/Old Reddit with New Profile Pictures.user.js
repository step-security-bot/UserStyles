// ==UserScript==
// @name         Old Reddit with New Reddit Profile Pictures
// @namespace    http://tampermonkey.net/
// @version      1.8
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
        return new Promise((resolve, reject) => {
            const requests = uncachedUsernames.map(username => {
                return new Promise((resolve, reject) => {
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
                });
            });

            Promise.all(requests)
                .then(results => {
                    resolve(usernames.map(username => profilePictureCache[username]));
                })
                .catch(error => {
                    reject(error);
                });
        });
    }

    async function injectProfilePictures(comments) {
        console.log(`Comments found: ${comments.length}`);
        const usernames = Array.from(comments).map(comment => comment.textContent.trim());
        const profilePictureUrls = await fetchProfilePictures(usernames);

        comments.forEach((comment, index) => {
            const username = usernames[index];
            const profilePictureUrl = profilePictureUrls[index];
            if (profilePictureUrl) {
                console.log(`Injecting profile picture: ${username}`);
                const img = document.createElement('img');
                img.src = profilePictureUrl;
                img.classList.add('profile-picture');
                img.onerror = () => { img.style.display = 'none'; };
                img.addEventListener('click', () => { window.open(profilePictureUrl, '_blank'); });
                if (!comment.previousElementSibling || !comment.previousElementSibling.classList.contains('profile-picture')) {
                    comment.insertAdjacentElement('beforebegin', img);
                }
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
            }
        });
        console.log('Profile pictures injected');
    }

    function setupObserver() {
        const observer = new MutationObserver((mutations) => {
            const comments = document.querySelectorAll('.author, .c-username');
            if (comments.length > 0) {
                console.log('New comments detected');
                observer.disconnect();
                injectProfilePictures(comments);
            }
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
    `;
    document.head.appendChild(style);
})();