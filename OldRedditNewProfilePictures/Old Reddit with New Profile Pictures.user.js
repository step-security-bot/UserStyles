// ==UserScript==
// @name         Old Reddit with New Reddit Profile Pictures
// @namespace    http://tampermonkey.net/
// @version      1.1
// @description  Injects new Reddit profile pictures into Old Reddit next to the username
// @author       Nick2bad4u
// @match        https://*.reddit.com/*
// @match        https://www.*.reddit.com/*
// @grant        none
// @updateURL    https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/OldRedditNewProfilePictures/Old%20Reddit%20with%20New%20Profile%20Pictures.user.js
// @downloadURL  https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/OldRedditNewProfilePictures/Old%20Reddit%20with%20New%20Profile%20Pictures.user.js
// ==/UserScript==

(function() {
    'use strict';

    // Create a cache object
    const profilePictureCache = {};

    // Function to fetch new Reddit profile picture
    async function fetchProfilePicture(username) {
        // Check if the profile picture is already in the cache
        if (profilePictureCache[username]) {
            return profilePictureCache[username];
        }

        const response = await fetch(`https://www.reddit.com/user/${username}/about.json`);
        const data = await response.json();

        // Remove parameters from the URL
        const profilePictureUrl = data.data.icon_img.split('?')[0];

        // Store the profile picture URL in the cache
        profilePictureCache[username] = profilePictureUrl;

        return profilePictureUrl;
    }

    // Function to inject profile pictures into the comment section
    async function injectProfilePictures() {
        const comments = document.querySelectorAll('.author');
        const fetchPromises = Array.from(comments).map(async (comment) => {
            const username = comment.textContent;
            const profilePictureUrl = await fetchProfilePicture(username);

            if (profilePictureUrl) {
                const img = document.createElement('img');
                img.src = profilePictureUrl;
                img.classList.add('profile-picture');
                img.onerror = () => {
                    img.style.display = 'none';
                };
                img.addEventListener('click', () => {
                    window.open(profilePictureUrl, '_blank');
                });
                comment.parentNode.insertBefore(img, comment);

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

                img.addEventListener('mouseout', () => {
                    enlargedImg.style.display = 'none';
                });
            }
        });

        await Promise.all(fetchPromises);
    }

    window.addEventListener('load', injectProfilePictures);

    // Add CSS to style the images
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
            cursor: pointer; /* Add cursor pointer for clickable images */
        }
        .enlarged-profile-picture {
            width: 150px; /* Increased size */
            height: 150px; /* Increased size */
            border-radius: 50%;
            position: absolute;
            display: none;
            z-index: 1000;
            pointer-events: none;
            outline: 2px solid #000; /* Add outline */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 1); /* Add shadow */
            background-color: rgba(0, 0, 0, 1); /* Add black background */
        }
    `;
    document.head.appendChild(style);
})();
