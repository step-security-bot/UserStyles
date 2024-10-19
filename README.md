[![CodeQL](https://github.com/Nick2bad4u/UserStyles/actions/workflows/codeql.yml/badge.svg)](https://github.com/Nick2bad4u/UserStyles/actions/workflows/codeql.yml)
[![Dependabot Updates](https://github.com/Nick2bad4u/UserStyles/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/Nick2bad4u/UserStyles/actions/workflows/dependabot/dependabot-updates)
[![Dependency Review](https://github.com/Nick2bad4u/UserStyles/actions/workflows/dependency-review.yml/badge.svg)](https://github.com/Nick2bad4u/UserStyles/actions/workflows/dependency-review.yml)
[![pages-build-deployment](https://github.com/Nick2bad4u/UserStyles/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/Nick2bad4u/UserStyles/actions/workflows/pages/pages-build-deployment)
[![Scorecard supply-chain security](https://github.com/Nick2bad4u/UserStyles/actions/workflows/scorecards.yml/badge.svg)](https://github.com/Nick2bad4u/UserStyles/actions/workflows/scorecards.yml)

![RepoBeats](https://repobeats.axiom.co/api/embed/9831c07785869d711723400c1b0acbae9d78dc50.svg "Repobeats analytics image")
# Typpi's UserStyles
Collection of UserStyles made by Typpi.

Styles also hosted here: https://userstyles.world/user/Nick2bad4u
```
/* ==UserStyle==
@name         Wigle.net Dark Mode
@version      20240926.22.59
@namespace    wigle.net
@description  Dark Mode for Wigle.net
@author       Nick2bad4u
@license      The UnLicense
==/UserStyle== */
@-moz-document domain("wigle.net") {
	:root {
		filter: invert(1);
		/*            background-color: black; */
	}
	img:not(.mwe-math-fallback-image-display):not(.mwe-math-fallback-image-inline):not(img[alt="GPS"]):not(img[alt="Cell"]):not(img[alt="WiFi"]):not(img[alt="BT"]) {
		filter: invert(1);
	}
	.mw-logo {
		filter: invert(100%);
	}
}
```
```
/* ==UserStyle==
@name         Wikipedia × OLED Pro Deep Black theme
@namespace    USO Archive
@author       GoodDay
@description  This theme is meant for OLED displays but it should work well for Extreme Dynamic Range (XDR) displays as well. Extremely simple and clean Wikipedia dark theme with minimal changes. It has an improved contrast over existing Wikipedia themes. No textured background. Does not modify the layout. Should work for all languages and localizations.  Requests and fixes welcome in comments.
@version      20240714.20.09
@license      NONE
@preprocessor uso
==/UserStyle== */
@-moz-document regexp("https://..*wikipedia.org/wiki/Special:Preferences") {
    :root {
        filter: invert(1);
        /*            background-color: black; */
    }
    img:not(.mwe-math-fallback-image-display):not(.mwe-math-fallback-image-inline) {
        filter: invert(1);
    }
    .mw-logo {
        filter: invert(100%);
    }
}
```
```
/* ==UserStyle==
@name         kiwifarms - Vaporwave
@namespace    USO Archive
@author       Lucifuga
@description  Still waiting for a vaporwave forum theme
@version      20180102.22.40
@license      CC0-1.0
@preprocessor uso
==/UserStyle== */
@-moz-document domain("kiwifarms.st") {
	.navTabs .navTab.selected .navLink,
	.PageNav a:focus,
	.nodeIcon.hasGlyph,
	.node .subForumList .unread .nodeTitle,
	.breadcrumb .crust:last-child a.crumb,
	#forumrules .jawsh_forumrules_text a,
	.AttributionLink,
	.ugc a:link,
	.sidebar .visitorPanel .username,
	.navigationSideBar a:hover,
	.discussionListItems .unread .title a,
	.discussionListItems .unread .lastPostInfo .username,
	.externalLink.ProxyLink,
	.message .messageMeta .control:hover,
	.redactor_toolbar li a.redactor_act,
	.xenOverlay.memberCard .userInfo h3 a,
	.xenOverlay.memberCard .userLinks,
	.messageContent .username.poster,
	.message .messageMeta .control:hover,
	.messageMeta .publicControls .LikeLink.item.control.like,
	a.CommentPoster.item.control.postComment,
	ul.links a,
	a.username.primaryText,
	a.internalLink,
	h3.title.thread a,
	h4.minorTitle.forum a,
	h3.description a,
	.contactInfo dd a,
	a.username.StatusTooltip.NoOverlay,
	h3.ctaFtAuthorTitle a,
	.chooserColumns .title,
	.profileContent h3.title a,
	.uix_postbit_privateControlsMenu:hover,
	.dark_postrating_list.OverlayTrigger,
	.bigFooterCol .footerMenu a,
	.footer a,
	.navTabs .navLink,
	.navTabs .SplitCtrl,
	.sectionFooter a,
	.concealed,
	.blockLinksList a,
	.nodeList .categoryStrip .nodeTitle a,
	.ctrlUnit.sectionLink dt a,
	.subHeading,
	a.secondaryContent,
	a.primaryContent,
	ABBR.DateTime.muted.lastThreadDate,
	.discussionListItem .lastPostInfo .username,
	.discussionListItem .titleText,
	body .muted a,
	.textCtrl,
	.breadcrumb .crust a.crumb,
	a.PopupItemLink,
	.profilePage .tabs.mainTabs li a,
	.searchResult .meta a,
	.ctaFtAuthorMeta a,
	.ctaFtAuthorListItem .ctaFtAuthorSnippet a,
	a.ctaFtReadMoreLink,
	a.ctaFtThreadTitleLink {
		color: #33ccff !important;
	}
	.sidebar .avatarList .userTitle,
	SPAN.nodeIcon.hasGlyph,
	.messageText,
	blockquote,
	.message .editDate,
	.ctaFtThreadTextAvatar,
	.sidebar .section .secondaryContent .footnote,
	.sidebar .section .secondaryContent .minorHeading,
	.sidebar .section .primaryContent h3,
	.sidebar .section .secondaryContent h3,
	.profilePage .mast .section.infoBlock h3,
	.pairsJustified dd,
	.pairsJustified dt,
	#pageDescription,
	.titleBar h1,
	.message .dark_postrating.likesSummary,
	#lolcow-llc,
	#canary,
	label,
	.discussionListItem .subtitle,
	.memberListItem .member .contentInfo,
	.ctaFtReplies,
	.ctaFtFeaturedThreadText,
	.bigFooterHeader .uix_icon,
	.bigFooterHeader,
	.bigFooter .pageContent,
	.jawsh-randomquote-quote,
	.Menu .secondaryContent,
	.Menu .menuHeader .muted,
	.Menu .menuHeader h3,
	.PageNav .pageNavHeader,
	.sectionFooter,
	.pollBlock .question .questionText,
	body .muted,
	.pollBlock .questionMark,
	.xenOverlay .section .heading,
	.pairsInline dt,
	.dark_postrating_header,
	.dark_postrating_header strong,
	.button.primary,
	.ctrlUnit > dt dfn,
	.ctrlUnit > dd > * > li .hint,
	.ctrlUnit > dd .explain,
	.CurrentStatus,
	.statusEditorCounter,
	.heading,
	.node .nodeLastPost .lastThreadTitle,
	.sidebar .avatarList .userTitle,
	.button,
	H3.primaryContent,
	#forumrules,
	.ctaFtDate,
	.alertText,
	.textHeading,
	.xenOverlay.memberCard,
	.xenOverlay.memberCard .userInfo h4,
	.profilePage .primaryUserBlock h1,
	.pairsInline dd,
	.likesSummary.secondaryContent,
	.dark_postrating_neutral,
	.profilePage .primaryUserBlock .userBlurb,
	.profilePage .primaryUserBlock .userStatus,
	.searchResult .meta,
	.searchResult .contentType,
	.pairsColumns dt,
	.pairsColumns dd,
	.signature,
	.ctaFtAuthorMeta,
	.baseHtml.ugc,
	.event .content .description,
	.event .content .snippet,
	.event .content .DateTime,
	#NoProfilePosts,
	.bbCodeQuote .attribution,
	.message .newIndicator,
	#SignupButton .inner,
	.messageUserBlock .userTitle {
		color: #ffccff !important;
	}
	#userBar .navTabs,
	.navTabs .navTab.Popup.PopupOpen,
	#QuickSearch .primaryControls .uix_icon,
	#SignupButton .inner,
	.message .newIndicator,
	.button.primary,
	.heading,
	.xenForm .formHeader,
	.userBanner.bannerStaff,
	#uix_jumpToFixed,
	.message .publicControls .MultiQuoteControl.active,
	.pollBlock .buttons .button,
	.button {
		background-color: #33ccff !important;
	}
	a.callToAction span,
	.PageNav a.currentPage {
		background-color: #33ccff !important;
		color: #ffccff !important;
	}
	a:link,
	.node .unread .nodeText .nodeTitle,
	SPAN.DateTime.muted.lastThreadDate,
	span.DateTime,
	#copyrightCompliance,
	.secondaryContent a {
		color: #33ccff !important;
	}
	body {
		background-image: none !important;
		background-color: #333333 !important;
	}
	.nodeList .categoryStrip,
	.nodeList,
	#content .pageContent,
	.ctaFtBackground,
	.secondaryContent,
	.nodeList .forumNodeInfo,
	.sidebar .section .secondaryContent h3,
	.footer .choosers a,
	.sectionFooter,
	.breadcrumb,
	.breadcrumb .crust a.crumb,
	#uix_wrapper,
	.pageContent,
	.navTabs .navTab.selected .tabLinks {
		background-color: #333333 !important;
	}
	.forum_list .nodeList .nodeList,
	.sectionMain.ctaFtContainer,
	.sidebar .section .secondaryContent h3,
	.footer .choosers a,
	.messageList .message,
	.breadcrumb {
		border-color: #ffccff !important;
	}
	.navTabs,
	.navTabs .navTab.selected .navLink {
		border-top-color: #ffccff;
		border-left-color: #ffccff;
		border-right-color: #ffccff;
		border-bottom-color: #ffccff;
		background-color: #333333 !important;
	}
	.PageNav a.currentPage,
	.textCtrl:focus,
	.textCtrl.Focus,
	.xenOverlay .formOverlay .textCtrl:focus,
	.xenOverlay .formOverlay .textCtrl.Focus,
	.profilePage .mast .section.infoBlock,
	.messageSimple {
		border-top-color: #ffccff;
		border-right-color: #ffccff;
		border-bottom-color: #ffccff;
		border-left-color: #ffccff;
	}
	.discussionList .discussionListItem.sticky {
		border-top-color: #ffccff;
		border-bottom-color: #ffccff;
	}
	.discussionListItem:nth-child(2n),
	.discussionListItem {
		border-bottom-color: #ffccff;
	}
	.breadcrumb .crust .arrow span {
		border-color: #ffccff #464646 #464646;
		border-top-color: #ffccff;
	}
	.message .messageDetails {
		border-top-color: #ffccff;
	}
	.navTabs .navTab.selected .tabLinks {
		border-color: #ffccff;
	}
	.Menu {
		border-color: #ffccff #464646 #464646;
		border-top-color: #ffccff;
	}
	.message .publicControls .MultiQuoteControl.active {
		color: #FFF !important;
	}
	.footer .choosers a:hover {
		border-color: #464646 !important;
		color: #ffccff !important;
	}
	.navTabs .navTab.selected.PopupOpen .navLink,
	.navTabs .navTab.selected.PopupOpen .navLink {
		color: #FFF !important;
		background-color: #ffccff !important;
	}
	#uix_wrapper,
	#content .pageContent,
	.sidebar .section .secondaryContent,
	.footer .pageContent,
	.sectionMain,
	.DiscussionListOptions {
		border-color: #ffccff;
	}
	.node.level_2 .nodeInfo {
		border-top-color: #ffccff;
	}
	.PageNav a:hover {
		background-color: #292C2E !important;
		color: #ffccff!important;
	}
	.button:hover,
	#SignupButton:hover .inner {
		background-color: #4A4E51 !important;
	}
	.ugc a:hover,
	.ugc a:focus {
		box-shadow: 0px 1px 0px #ffccff !important;
	}
	#logo img {
		height: 0 !important;
		width: 0 !important;
		padding-left: 200px !important;
		padding-top: 75px !important;
		background: url(http://i.cubeupload.com/Cw1wYQ.png) no-repeat !important;
	}
}
```
```
/* ==UserStyle==
@name         Unroll.me Dark Mode
@version      20241013.22.59
@namespace    Unroll.me
@description  Dark Mode for Unroll.me
@author       Nick2bad4u
@license      The UnLicense
==/UserStyle== */
@-moz-document domain("unroll.me") {
	:root {
		filter: invert(1);
		/*            background-color: black; */
	}
	img:not(.mwe-math-fallback-image-display):not(.mwe-math-fallback-image-inline):not(img[alt = "GPS"]) {
		filter: invert(1);
	}
	.mw-logo {
		filter: invert(100%);
	}
}
```
```
/* Dark Mode Theme for Klimat Weather Page */
/* ==UserStyle==
@name         klimat.app - Dark Mode
@version      20241018.02.49
@namespace    klimat.app
@description  Klimat.app Dark Mode
@author       Nick2bad4u@hotmail.com
@license      UnLicense
==/UserStyle== */
body {
	background-color: #121212;
	color: #e0e0e0;
}

header,
footer,
.sidebar,
.content {
	background-color: #1e1e1e;
	color: #e0e0e0;
}

a {
	color: #bb86fc;
}

a:hover {
	color: #3700b3;
}

table {
	background-color: #1e1e1e;
	color: #e0e0e0;
}

table th,
table td {
	border: 1px solid #333;
}

button,
input,
select,
textarea {
	background-color: #333;
	color: #e0e0e0;
	border: 1px solid #444;
}

button:hover,
input:hover,
select:hover,
textarea:hover {
	background-color: #444;
}

::selection {
	background-color: #bb86fc;
	color: #121212;
}

span {
	color: #BB86FC;
}

#content_wrapper {
	filter: invert(1)
}
```
```
body,
.panel-body,
.toolsSection,
td,
#resultColumn,
ul,
div#newsBar,
.newsItem,
.contentall.contentwithheader.row,
.dd-selected,
ol.breadcrumb,
.searchControl,
#wigleMain > ul > li.active > a {
	background-color: #121212;
	color: #ffffff;
}
.navbar,
.footer,
.dropdown-menu,
.modal-content {
	background-color: #1e1e1e;
	border-color: #444;
}
.navbar-brand img,
.navbar-toggle .icon-bar,
.navbar-nav > li > a,
.dropdown-menu > li > a,
#map_ext_wrapper,
input.mapfilter,
input#savelinkhereID {
	filter: invert(1);
}
input,
select,
textarea {
	background-color: #333;
	color: #ffffff;
	border: 1px solid #666;
}
a {
	color: #bb86fc;
}
.btn,
.btn-default,
.btn-block {
	background-color: #333;
	color: #ffffff;
	border: 1px solid #666;
}
.form-control {
	background-color: #333;
	color: #ffffff;
}
.mapBarItem,
.mapForm,
.mapFilter,
.mapBarSlider,
.mapBarStatus,
.mapBarShowHide,
.mapBarItem table,
.mapBarItem input,
.mapBarItem select,
.mapBarItem label {
	background-color: #1e1e1e;
	color: #ffffff;
}
.statsGraphInner,
.statsgraphcontainer,
.graphContextLinks,
.graphCaption {
	background-color: #1e1e1e;
	color: #ffffff;
}
.hilite-stats {
	color: #bb86fc;
}
.modal-header,
.modal-footer,
.jumbotron {
	background-color: #1e1e1e;
	color: #ffffff;
}
.modal-header .close {
	color: #ffffff;
}
.modal-body {
	background-color: #1e1e1e;
	color: #ffffff;
}
.container,
.row,
.col-sm-12,
.col-sm-9,
.col-sm-3,
.col-sm-2,
.col-sm-1 {
	background-color: #1e1e1e;
	color: #fff;
}
#newsBar,
.graphCaption,
.pageControls {
	color: #000000;
}
#uploadsTable,
#mapBar {
	filter: invert(1);
}
```
```
/* ==UserStyle==
@name         Gyazo.com Dark Mode
@version      20241018.21.02
@namespace    https://userstyles.world/user/Nick2bad4u
@description  Gyazo Dark Mode (WIP)
@author       Nick2bad4u
@license      UnLicense
==/UserStyle== */

@-moz-document domain("gyazo.com") {
/* Additional elements */
.header-block,
.footer-block,
.content-block,
.sidebar-block,
.side-block-items,
.images-grid-view,
.grid-view,
.grid-view-cell,
.grid-view-cell-inner-image,
.main-block-stage,
.image-infos,
.captured-info-value,
.edit-box-component,
.image-desc-display.placeholder {
	background-color: #121212 !important;
	color: #e0e0e0 !important;
}

/* Links, buttons, inputs, images */
a,
span,
button,
input,
img,
.header-block.explorer-header-block {
	color: #bb86fc !important;
	background-color: #121212 !important;
}

/* Form controls, grid cells */
.button,
.input,
.form-control,
.grid-cell,
.related-images-grid-view.related-info {
	background-color: #1e1e1e !important;
	color: #e0e0e0 !important;
	border: 1px solid #333 !important;
}

/* Header and footer borders */
.header-block,
.footer-block {
	border-bottom: 1px solid #333 !important;
}

/* Sidebar border */
.sidebar-block {
	border-right: 1px solid #333 !important;
}

/* Card styling */
.card.medium-card {
	background-color: #1e1e1e !important;
	color: #bb86fc !important;
	border: 1px solid #333 !important;
}

/* Metadata and related info */
.metadata,
.images-after-origin,
.container-close-date-images.related-info,
.related-info-box-component,
.testing-swap-image-container,
.metadata-baseinfo {
	background-color: #1e1e1e !important;
	color: #bb86fc !important;
	border: 1px solid #333 !important;
}

/* Additional elements */
div,
p,
h1,
h2,
h3,
h4,
h5,
h6,
ul,
li,
table,
th,
td,
section,
article,
aside,
nav,
header,
footer,
main {
	background-color: #121212 !important;
	color: #e0e0e0 !important;
}

.modal,
.modal-content {
	background-color: #1e1e1e !important;
	color: #e0e0e0 !important;
	border: 1px solid #333 !important;
}

.tooltip,
.popup {
	background-color: #1e1e1e !important;
	color: #e0e0e0 !important;
	border: 1px solid #333 !important;
}

select,
option {
	background-color: #1e1e1e !important;
	color: #e0e0e0 !important;
}
}
```
```
/* ==UserStyle==
@name         Wigle.net Dark Mode (Beta)
@version      20241018.02.33
@namespace    https://userstyles.world/user/Nick2bad4u
@description  Dark Mode (Beta) for Wigle.net
@author       Nick2bad4u
@license      UnLicense
==/UserStyle== */

@-moz-document domain("wigle.net") {
body,
.panel-body,
.toolsSection,
td,
#resultColumn,
ul,
div#newsBar,
.newsItem,
.contentall.contentwithheader.row,
.dd-selected,
ol.breadcrumb,
.searchControl,
#wigleMain > ul > li.active > a {
	background-color: #121212;
	color: #ffffff;
}
.navbar,
.footer,
.dropdown-menu,
.modal-content {
	background-color: #1e1e1e;
	border-color: #444;
}
.navbar-brand img,
.navbar-toggle .icon-bar,
.navbar-nav > li > a,
.dropdown-menu > li > a,
#map_ext_wrapper,
input.mapfilter,
input#savelinkhereID {
	filter: invert(1);
}
input,
select,
textarea {
	background-color: #333;
	color: #ffffff;
	border: 1px solid #666;
}
a {
	color: #bb86fc;
}
.btn,
.btn-default,
.btn-block {
	background-color: #333;
	color: #ffffff;
	border: 1px solid #666;
}
.form-control {
	background-color: #333;
	color: #ffffff;
}
.mapBarItem,
.mapForm,
.mapFilter,
.mapBarSlider,
.mapBarStatus,
.mapBarShowHide,
.mapBarItem table,
.mapBarItem input,
.mapBarItem select,
.mapBarItem label {
	background-color: #1e1e1e;
	color: #ffffff;
}
.statsGraphInner,
.statsgraphcontainer,
.graphContextLinks,
.graphCaption {
	background-color: #1e1e1e;
	color: #ffffff;
}
.hilite-stats {
	color: #bb86fc;
}
.modal-header,
.modal-footer,
.jumbotron {
	background-color: #1e1e1e;
	color: #ffffff;
}
.modal-header .close {
	color: #ffffff;
}
.modal-body {
	background-color: #1e1e1e;
	color: #ffffff;
}
.container,
.row,
.col-sm-12,
.col-sm-9,
.col-sm-3,
.col-sm-2,
.col-sm-1 {
	background-color: #1e1e1e;
	color: #fff;
}
#newsBar,
.graphCaption,
.pageControls {
	color: #000000;
}
#uploadsTable,
#mapBar {
	filter: invert(1);
}
}
```
```
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
```