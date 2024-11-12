// ==UserScript==
// @name         Allow Right-Click with Tampermonkey Menu Option
// @namespace    https://github.com/Nick2bad4u/UserStyles
// @version      1.4
// @description  Allows right-clicking on websites that prevent it, with an option in the Tampermonkey menu to activate the feature
// @author       Nick2bad4u
// @match        *://*/*
// @grant        GM_registerMenuCommand
// @icon         https://i.gyazo.com/353b60294e0dc77af7119d58ab0aa1ad.png
// @updateURL    https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/RightCLickEnable.user.js
// @downloadURL  https://github.com/Nick2bad4u/UserStyles/raw/refs/heads/main/RightCLickEnable.user.js
// @license      UnLicense
// @tag          all
// ==/UserScript==

(function() {
    'use strict';

    // Function to enable right-click
    function enableRightClick() {
        document.addEventListener('contextmenu', function(event) {
            event.stopPropagation();
        }, true);

        document.addEventListener('mousedown', function(event) {
            if (event.button === 2) {
                event.stopPropagation();
            }
        }, true);

        document.addEventListener('mouseup', function(event) {
            if (event.button === 2) {
                event.stopPropagation();
            }
        }, true);

        alert('Right-click has been enabled!');
    }

    // Register the option in the Tampermonkey menu
    GM_registerMenuCommand("Enable Right-Click", enableRightClick);
})();
