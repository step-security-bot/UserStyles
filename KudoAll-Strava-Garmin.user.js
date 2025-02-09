// ==UserScript==
// @name         Strava and Garmin Kudos All (Working)
// @namespace    typpi.online
// @version      1.7
// @description  Adds a button to give kudos to all visible activities on Strava and Garmin Connect.
// @author       Nick2bad4u
// @license      Unlicense
// @homepageURL  https://github.com/Nick2bad4u/UserStyles/
// @grant        none
// @run-at       document-end
// @include      https://www.strava.com/*
// @include      https://connect.garmin.com/modern/*
// @icon         https://i.gyazo.com/e2fabcfc9e9fd6d011e98215764c109c.png
// ==/UserScript==

(function () {
	'use strict';

	// Function to get localized message
	function getMessage(messageName, substitutions) {
		const messages = {
			en: { kudo_all: 'Kudo All' },
			es: { kudo_all: 'Dar Kudos a Todos' },
			fr: { kudo_all: 'Féliciter Tout le Monde' },
			de: { kudo_all: 'Allen Kudos geben' },
			it: { kudo_all: 'Dai Kudos a Tutti' },
			pt: { kudo_all: 'Dar Kudos a Todos' },
			nl: { kudo_all: 'Geef Kudos aan Iedereen' },
			ru: { kudo_all: 'Похвалить всех' },
			zh: { kudo_all: '赞所有' },
			ja: { kudo_all: '全員にKudos' },
			ko: { kudo_all: '모두에게 칭찬하기' },
			ar: { kudo_all: 'إعطاء Kudos للجميع' },
			hi: { kudo_all: 'सभी को कुडोस दें' },
			bn: { kudo_all: 'সবাইকে কুডোস দিন' },
			te: { kudo_all: 'అన్నికి కుడోస్ ఇవ్వండి' },
			ta: { kudo_all: 'அனைத்துக்கும் குடோஸ் கொடுக்கவும்' },
			ml: { kudo_all: 'എല്ലാവര്‍ക്കും ക,ഡോസ് നല്‍കുക' },
			th: { kudo_all: 'ให้คุดดอกทุกคน' },
			vi: { kudo_all: 'Kudo Tất cả' },
			tr: { kudo_all: 'Herkese Kudos Ver' },
			pl: { kudo_all: 'Pochwal wszystkich' },
			cs: { kudo_all: 'Pošli Kudos všem' },
			sk: { kudo_all: 'Pošli Kudos všetkým' },
			hu: { kudo_all: 'Kudos Mindenkinek' },
			ro: { kudo_all: 'Felicită pe Toată Lumea' },
			hr: { kudo_all: 'Pošalji Kudos svima' },
			sr: { kudo_all: 'Пошаљи Кудос свима' },
			sl: { kudo_all: 'Pošlji Kudos vsem' },
			et: { kudo_all: 'Saada Kudos kõigile' },
			lv: { kudo_all: 'Sūtīt Kudos visiem' },
			lt: { kudo_all: 'Siųsti Kudos visiems' },
			bg: { kudo_all: 'Изпрати Кудос на всички' },
			el: { kudo_all: 'Στείλτε Kudos σε όλους' },
			uk: { kudo_all: 'Похвалити всіх' },
			be: { kudo_all: 'Пахваліць усіх' },
			hy: { kudo_all: 'Բոլորին տալ Kudos' },
			ka: { kudo_all: 'ყოფნა Kudos ყველი' },
			az: { kudo_all: 'Bütün Kudos göndər' },
		};

		const userLanguage = navigator.language.split('-')[0]; // Get the user's language
		const messageSet = messages[userLanguage] || messages['en']; // Default to English if language not supported

		return messageSet[messageName] || substitutions || messageName;
	}

	const Strava = {
		getStravaContainer,
		findStravaKudosButtons,
		createStravaFilter,
		getStravaKudosButtons,
		createStravaButton,
		stravaKudoAllHandler,
		stravaStandBy,
	};

	function getStravaContainer() {
		const container = document.querySelector('[class="user-nav nav-group"]');
		console.log('Strava: Found container:', container);
		return container;
	}

	function findStravaKudosButtons(container) {
		const kudosButtonSelector = "button[data-testid='kudos_button']";
		const unfilledKudosSelector = "svg[data-testid='unfilled_kudos']";
		const selector = `${kudosButtonSelector} > ${unfilledKudosSelector}`;
		const buttons = container ? [...container.querySelectorAll(selector)] : [...document.querySelectorAll(selector)];
		console.log('Strava: Found kudos buttons:', buttons);
		return buttons;
	}

	function createStravaFilter(athleteLink) {
		const href = athleteLink.href.replace(/https:\/\/(www\.)?strava\.com/, '');
		console.log('Strava: Filter created for athlete link:', href);
		return (item) => !item.querySelector(`a[href^="${href}"]`);
	}

	function getStravaKudosButtons() {
		const athleteLink = document.querySelector("#athlete-profile a[href^='/athletes']");
		console.log('Strava: Athlete link:', athleteLink);

		if (!athleteLink) {
			return findStravaKudosButtons(document);
		}

		let activities = document.querySelectorAll("div[data-testid='web-feed-entry']");
		console.log('Strava: Found activities:', activities);

		if (activities.length < 1) {
			return findStravaKudosButtons();
		}

		activities = Array.from(activities).filter(createStravaFilter(athleteLink));
		console.log('Strava: Filtered activities:', activities);

		if (activities.length < 1) {
			return findStravaKudosButtons();
		}

		const buttons = activities.reduce((acc, activity) => {
			const buttons = findStravaKudosButtons(activity);
			return acc.concat(buttons.filter((item) => !!item));
		}, []);
		console.log('Strava: Final kudos buttons:', buttons);
		return buttons;
	}

	function createStravaButton() {
		const label = getMessage('kudo_all', 'Kudo All');
		console.log('Strava: Creating button with label:', label);

		const navItemLi = document.createElement('li');
		const navItemA = document.createElement('a');

		navItemLi.className = 'nav-item';
		navItemLi.style.marginRight = '10px';

		navItemA.href = '#';
		navItemA.className = 'btn btn-default btn-sm empty';

		const navItemIcon = document.createElement('span');
		navItemIcon.className = 'app-icon icon-kudo';
		navItemIcon.style.marginRight = '5px';

		const navItemText = document.createElement('span');
		navItemText.className = 'ka-progress text-caption1';
		navItemText.textContent = label;

		navItemA.append(navItemIcon);
		navItemA.append(navItemText);
		navItemLi.append(navItemA);

		return navItemLi;
	}

	function stravaKudoAllHandler(event) {
		event.preventDefault();

		const icons = getStravaKudosButtons();
		console.log('Strava: Clicking all kudos buttons, count:', icons.length);

		icons.forEach((item) => {
			const parentItem = item?.parentElement;
			if (parentItem) {
				parentItem.click();
			}
		});
	}

	function stravaStandBy() {
		console.log('Strava: Standby initiated');
		const buttonExisted = document.querySelector('div[class="ka-progress text-caption1"]');
		if (!buttonExisted) {
			console.log('Strava: Button does not exist, creating');

			const container = getStravaContainer();

			if (container) {
				const button = createStravaButton();
				container.prepend(button);
				button.addEventListener('click', stravaKudoAllHandler);
			}
		}
	}

	const GC = {
		getGarminContainer,
		findGarminKudosButtons,
		createGarminButton,
		garminKudoAllHandler,
		executeGarmin,
		garminConnectStandBy,
	};

	function getGarminContainer() {
		const container = document.querySelector('div[class="header-nav"]');
		console.log('Garmin: Found container:', container);

		if (container) {
			const el = document.createElement('div');
			el.classList.add('kudo-all-nav-item', 'header-nav-item');
			el.style.height = '60px';
			el.style.width = '50px';
			container.prepend(el);
			return document.querySelector('div[class^=kudo-all-nav-item]');
		}
		return null;
	}

	function findGarminKudosButtons(container) {
		const selector = 'button[class^="CommentLikeSection_socialIconWrapper"] > div[class*="CommentLikeSection_animateBox"] > i[class*=icon-heart-inverted]';
		const buttons = container ? Array.from(container.querySelectorAll(selector)) : Array.from(document.querySelectorAll(selector));
		console.log('Garmin: Found kudos buttons:', buttons);
		return buttons;
	}

	function createGarminButton() {
		const label = getMessage('kudo_all', 'Kudo All');
		console.log('Garmin: Creating button with label:', label);

		const link = document.createElement('a');
		link.href = '#';
		link.className = 'header-nav-link icon-heart-inverted';
		link.setAttribute('aria-label', label);
		link.setAttribute('data-original-title', label);
		link.setAttribute('data-rel', 'tooltip');
		return link;
	}

	function garminKudoAllHandler(event) {
		event.preventDefault();
		if (window.location.pathname !== '/modern/newsfeed') {
			console.log('Garmin: Not on the newsfeed page, aborting');
			return;
		}

		const icons = findGarminKudosButtons();
		console.log('Garmin: Clicking all kudos buttons, count:', icons.length);

		icons.forEach((item) => {
			if (item) {
				item.click();
			}
		});
	}

	function executeGarmin() {
		console.log('Garmin: Execute function called');
		const container = getGarminContainer();

		if (container) {
			const button = createGarminButton();
			container.append(button);
			button.addEventListener('click', garminKudoAllHandler);
		}
	}

	function garminConnectStandBy() {
		console.log('Garmin: Standby initiated');

		let loaded = false;

		var observer = new MutationObserver(function (mutations) {
			mutations.forEach(function (mutation) {
				if (mutation.addedNodes.length > 0) {
					mutation.addedNodes.forEach((node) => {
						if (
							!loaded &&
							node.nodeType === 1 && // Ensure it's an element
							node.className &&
							typeof node.className === 'string' &&
							node.className.startsWith('header-nav')
						) {
							console.log('Garmin: Target element loaded, executing...');
							loaded = true;
							executeGarmin();
						}
					});
				}
			});
		});

		observer.observe(document.body, {
			childList: true,
			subtree: true,
		});
	}

	// Check if the current host is Strava
	function isHostStrava() {
		const currentHostname = window.location.hostname;
		const stravaDomainPattern = /^.*\.strava\.com$/;
		const isStrava = stravaDomainPattern.test(currentHostname);
		console.log('Host check: Is Strava?', isStrava);
		return isStrava;
	}

	// Check if the current host is Garmin
	function isHostGarmin() {
		const currentHostname = window.location.hostname;
		const garminDomainPattern = /^.*\.garmin\.com$/;
		const isGarmin = garminDomainPattern.test(currentHostname);
		console.log('Host check: Is Garmin?', isGarmin);
		return isGarmin;
	}

	// Initialize script on window load
	window.onload = function () {
		console.log('Kudo All Starts running....');

		const inStrava = isHostStrava();
		const inGarmin = isHostGarmin();

		if (inStrava) {
			console.log('Detected Strava domain. Initiating Strava standby...');
			Strava.stravaStandBy();
		} else if (inGarmin) {
			console.log('Detected Garmin domain. Initiating Garmin standby...');
			GC.garminConnectStandBy();
		} else {
			console.log('Unknown domain. No action taken.');
		}
	};
})();
