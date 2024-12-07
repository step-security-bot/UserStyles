// ==UserScript==
// @name         Strava and Garmin Kudos All (Working)
// @namespace    typpi.online
// @version      1.2
// @description  Adds a button to give kudos to all visible activities on Strava and Garmin Connect.
// @author       Nick2bad4u
// @license      Unlicense
// @homepageURL  https://userstyles.github.typpi.online/
// @grant        none
// @run-at       document-end
// @include      https://www.strava.com/*
// @include      https://connect.garmin.com/modern/*
// @icon         https://i.gyazo.com/e2fabcfc9e9fd6d011e98215764c109c.png
// ==/UserScript==

(function () {
	'use strict';

	function getMessage(
		messageName,
		substitutions,
	) {
		if (substitutions) {
			return substitutions;
		}
		return messageName;
	}

	const Strava = {
		getContainer: function () {
			const container = document.querySelector(
				'[class="user-nav nav-group"]',
			);
			console.log(
				'Strava: Found container:',
				container,
			);
			return container;
		},

		findKudosButtons: function (container) {
			const selector =
				"button[data-testid='kudos_button'] > svg[data-testid='unfilled_kudos']";
			const buttons = container
				? Array.from(
						container.querySelectorAll(selector),
					)
				: Array.from(
						document.querySelectorAll(selector),
					);
			console.log(
				'Strava: Found kudos buttons:',
				buttons,
			);
			return buttons;
		},

		createFilter: function (athleteLink) {
			const href = athleteLink.href
				.replace('https://www.strava.com', '')
				.replace('https://strava.com', '');
			console.log(
				'Strava: Filter created for athlete link:',
				href,
			);
			return (item) =>
				!item.querySelector(`a[href^="${href}"]`);
		},

		getKudosButtons: function () {
			const athleteLink = document.querySelector(
				"#athlete-profile a[href^='/athletes']",
			);
			console.log(
				'Strava: Athlete link:',
				athleteLink,
			);

			if (!athleteLink) {
				return Strava.findKudosButtons();
			}

			let activities = document.querySelectorAll(
				"div[data-testid='web-feed-entry']",
			);
			console.log(
				'Strava: Found activities:',
				activities,
			);

			if (activities.length < 1) {
				return Strava.findKudosButtons();
			}

			activities = Array.from(activities).filter(
				Strava.createFilter(athleteLink),
			);
			console.log(
				'Strava: Filtered activities:',
				activities,
			);

			if (activities.length < 1) {
				return Strava.findKudosButtons();
			}

			const buttons = activities
				.flatMap(Strava.findKudosButtons)
				.filter((item) => !!item);
			console.log(
				'Strava: Final kudos buttons:',
				buttons,
			);
			return buttons;
		},

		createButton: function () {
			const label = getMessage(
				'kudo_all',
				'Kudo All',
			);
			console.log(
				'Strava: Creating button with label:',
				label,
			);

			const navItemLi =
				document.createElement('li');
			const navItemA =
				document.createElement('a');

			navItemLi.className = 'nav-item';
			navItemLi.style.marginRight = '10px';

			navItemA.href = '#';
			navItemA.className =
				'btn btn-default btn-sm empty';

			const navItemIcon =
				document.createElement('span');
			navItemIcon.className =
				'app-icon icon-kudo';
			navItemIcon.style.marginRight = '5px';

			const navItemText =
				document.createElement('span');
			navItemText.className =
				'ka-progress text-caption1';
			navItemText.textContent = label;

			navItemA.append(navItemIcon);
			navItemA.append(navItemText);
			navItemLi.append(navItemA);

			return navItemLi;
		},

		kudoAllHandler: function (event) {
			event.preventDefault();

			const icons = Strava.getKudosButtons();
			console.log(
				'Strava: Clicking all kudos buttons, count:',
				icons.length,
			);

			icons.forEach((item) => {
				const parentItem = item?.parentElement;
				if (parentItem) {
					parentItem.click();
				}
			});
		},

		stravaStandBy: function () {
			console.log('Strava: Standby initiated');
			const buttonExisted =
				document.querySelector(
					'div[class="ka-progress text-caption1"]',
				);
			if (!buttonExisted) {
				console.log(
					'Strava: Button does not exist, creating',
				);

				const container = Strava.getContainer();

				if (container) {
					const button = Strava.createButton();
					container.prepend(button);
					button.addEventListener(
						'click',
						Strava.kudoAllHandler,
					);
				}
			}
		},
	};

	const GC = {
		getContainer: function () {
			const container = document.querySelector(
				'div[class="header-nav"]',
			);
			console.log(
				'Garmin: Found container:',
				container,
			);

			if (container) {
				const el = document.createElement('div');
				el.classList.add(
					'kudo-all-nav-item',
					'header-nav-item',
				);
				el.style.height = '60px';
				el.style.width = '50px';
				container.prepend(el);
				return document.querySelector(
					'div[class^=kudo-all-nav-item]',
				);
			}
			return null;
		},

		findKudosButtons: function (container) {
			const selector =
				'button[class^="CommentLikeSection_socialIconWrapper"] > div[class*="CommentLikeSection_animateBox"] > i[class*=icon-heart-inverted]';
			const buttons = container
				? Array.from(
						container.querySelectorAll(selector),
					)
				: Array.from(
						document.querySelectorAll(selector),
					);
			console.log(
				'Garmin: Found kudos buttons:',
				buttons,
			);
			return buttons;
		},

		createButton: function () {
			const label = getMessage(
				'kudo_all',
				'Kudo All',
			);
			console.log(
				'Garmin: Creating button with label:',
				label,
			);

			const link = document.createElement('a');
			link.href = '#';
			link.className =
				'header-nav-link icon-heart-inverted';
			link.setAttribute('aria-label', label);
			link.setAttribute(
				'data-original-title',
				label,
			);
			link.setAttribute('data-rel', 'tooltip');
			return link;
		},

		kudoAllHandler: function (event) {
			event.preventDefault();
			if (
				window.location.pathname !==
				'/modern/newsfeed'
			) {
				console.log(
					'Garmin: Not on the newsfeed page, aborting',
				);
				return;
			}

			const icons = GC.findKudosButtons();
			console.log(
				'Garmin: Clicking all kudos buttons, count:',
				icons.length,
			);

			icons.forEach((item) => {
				if (item) {
					item.click();
				}
			});
		},

		execute: function () {
			console.log(
				'Garmin: Execute function called',
			);
			const container = GC.getContainer();

			if (container) {
				const button = GC.createButton();
				container.append(button);
				button.addEventListener(
					'click',
					GC.kudoAllHandler,
				);
			}
		},

		garminConnectStandBy: function () {
			console.log('Garmin: Standby initiated');

			let loaded = false;

			var observer = new MutationObserver(
				function (mutations) {
					mutations.forEach(function (mutation) {
						if (mutation.addedNodes.length > 0) {
							mutation.addedNodes.forEach(
								(node) => {
									if (
										!loaded &&
										node.nodeType === 1 && // Ensure it's an element
										node.className &&
										typeof node.className ===
											'string' &&
										node.className.startsWith(
											'header-nav',
										)
									) {
										console.log(
											'Garmin: Target element loaded, executing...',
										);
										loaded = true;
										GC.execute();
									}
								},
							);
						}
					});
				},
			);

			observer.observe(document.body, {
				childList: true,
				subtree: true,
			});
		},
	};

	const isHostStrava = function () {
		const currentHostname =
			window.location.hostname;
		const stravaDomainPattern =
			/^.*\.strava\.com$/;
		return stravaDomainPattern.test(
			currentHostname,
		);
	};

	const isHostGarmin = function () {
		const currentHostname =
			window.location.hostname;
		const garminDomainPattern =
			/^.*\.garmin\.com$/;
		const isGarmin = garminDomainPattern.test(
			currentHostname,
		);
		console.log(
			'Host check: Is Garmin?',
			isGarmin,
		);
		return isGarmin;
	};

	window.onload = function () {
		console.log('Kudo All Starts running....');

		const inStrava = isHostStrava();
		const inGarmin = isHostGarmin();

		if (inStrava) {
			console.log(
				'Detected Strava domain. Initiating Strava standby...',
			);
			Strava.stravaStandBy();
		} else if (inGarmin) {
			console.log(
				'Detected Garmin domain. Initiating Garmin standby...',
			);
			GC.garminConnectStandBy();
		} else {
			console.log(
				'Unknown domain. No action taken.',
			);
		}
	};
})();
