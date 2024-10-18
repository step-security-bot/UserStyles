[![CodeQL](https://github.com/Nick2bad4u/UserStyles/actions/workflows/codeql.yml/badge.svg)](https://github.com/Nick2bad4u/UserStyles/actions/workflows/codeql.yml)
[![Dependabot Updates](https://github.com/Nick2bad4u/UserStyles/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/Nick2bad4u/UserStyles/actions/workflows/dependabot/dependabot-updates)
[![Dependency Review](https://github.com/Nick2bad4u/UserStyles/actions/workflows/dependency-review.yml/badge.svg)](https://github.com/Nick2bad4u/UserStyles/actions/workflows/dependency-review.yml)
[![pages-build-deployment](https://github.com/Nick2bad4u/UserStyles/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/Nick2bad4u/UserStyles/actions/workflows/pages/pages-build-deployment)
[![Scorecard supply-chain security](https://github.com/Nick2bad4u/UserStyles/actions/workflows/scorecards.yml/badge.svg)](https://github.com/Nick2bad4u/UserStyles/actions/workflows/scorecards.yml)

![RepoBeats](https://repobeats.axiom.co/api/embed/9831c07785869d711723400c1b0acbae9d78dc50.svg "Repobeats analytics image")
# Typpi's UserStyles
Collection of UserStyles made by Typpi.
```
/* ==UserStyle==
@name         wigle.net
@version      20240920.03.42
@namespace    wigle.net
@description  Dark Mode for Wigle.net
@author       Typpi
@license      The UnLicense
==/UserStyle== */

@-moz-document domain("wigle.net") {
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
@name         Wikipedia × OLED Pro Deep Black theme
@namespace    USO Archive
@author       GoodDay
@description  This theme is meant for OLED displays but it should work well for Extreme Dynamic Range (XDR) displays as well. Extremely simple and clean Wikipedia dark theme with minimal changes. It has an improved contrast over existing Wikipedia themes. No textured background. Does not modify the layout. Should work for all languages and localizations.  Requests and fixes welcome in comments.
@version      20240714.20.09
@license      NONE
@preprocessor uso
==/UserStyle== */
@-moz-document url-prefix("https://en.wikipedia.org/wiki/Special:Preferences") {
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
