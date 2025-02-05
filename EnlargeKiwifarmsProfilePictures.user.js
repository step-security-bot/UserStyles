// ==UserScript==
// @name         Kiwifarms - Expand Avatars on Hover
// @namespace    typpi.online
// @version      1.1.0
// @description  Expand avatars on hover for Kiwifarms Users
// @author       Nick2bad4u
// @match        kiwifarms.com/*
// @match        kiwifarms.net/*
// @match        kiwifarms.ms/*
// @match        kiwifarms.ru/*
// @match        kiwifarms.is/*
// @match        kiwifarms.top/*
// @match        kiwifarms.tw/*
// @match        kiwifarms.hk/*
// @match        kiwifarms.nl/*
// @match        sneed.today/*
// @match        kiwifarms.pl/*
// @match        kiwifarms.st/*
// @connect      kiwifarms.st/*
// @grant        none
// @homepageURL  https://github.com/Nick2bad4u/UserStyles
// @license      Unlicense
// @resource     https://www.google.com/s2/favicons?sz=64&domain=kiwifarms.st
// @icon         https://www.google.com/s2/favicons?sz=64&domain=kiwifarms.st
// @icon64       https://www.google.com/s2/favicons?sz=64&domain=kiwifarms.st
// @tag          kiwifarms
// ==/UserScript==

(function () {
	'use strict';

	// Add custom styles for the expanded avatar
	const style = document.createElement('style');
	style.textContent = `
        .expanded-avatar {
            position: absolute;
            border: 2px solid #000;
            border-radius: 50%;
            max-width: 400px;
            max-height: 400px;
            z-index: 9999;
            display: none;
            scale: 2;
        }
    `;
	document.head.appendChild(style);

	// Create an element to show the expanded avatar
	const expandedAvatar = document.createElement('img');
	expandedAvatar.className = 'expanded-avatar';
	document.body.appendChild(expandedAvatar);

	// Function to show the expanded avatar
	function showExpandedAvatar(event) {
		const avatar = event.target;
		expandedAvatar.src = avatar.src;
		expandedAvatar.style.left = `${event.pageX + 60}px`;
		expandedAvatar.style.top = `${event.pageY + 60}px`;
		expandedAvatar.style.display = 'block';
	}

	// Function to hide the expanded avatar
	function hideExpandedAvatar() {
		expandedAvatar.style.display = 'none';
	}

	// Attach event listeners to avatar images
	document.querySelectorAll('.avatar img').forEach((avatar) => {
		avatar.addEventListener('mouseover', showExpandedAvatar);
		avatar.addEventListener('mouseout', hideExpandedAvatar);
	});

	// Update avatar position on mouse move
	document.addEventListener('mousemove', (event) => {
		if (expandedAvatar.style.display === 'block') {
			expandedAvatar.style.left = `${event.pageX + 60}px`;
			expandedAvatar.style.top = `${event.pageY + 60}px`;
		}
	});
})();
