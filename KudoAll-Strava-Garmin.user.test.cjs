const sinon = require('sinon');
const { expect } = require('chai');
const global = globalThis;
const { describe, it, beforeEach, afterEach } = require('mocha');

function getMessage(key) {
	if (global.navigator.language === 'en') {
		return 'Kudo All';
	}
	return 'Kudo All';
}

function getStravaContainer() {
	return global.document.querySelector('.strava-container');
}

function findStravaKudosButtons() {
	return global.document.querySelectorAll('.strava-kudos-button');
}

function createStravaButton() {
	return global.document.createElement('button');
}

function stravaKudoAllHandler(event, findButtons) {
	event.preventDefault();
	const buttons = findButtons();
	if (buttons && buttons.length > 0) {
		buttons.forEach(button => button.parentElement.click());
	}
}

function stravaStandBy() {
	const container = getStravaContainer();
	const button = createStravaButton();
	button.addEventListener('click', (event) => stravaKudoAllHandler(event, findStravaKudosButtons));
	container.prepend(button);
}

function getGarminContainer() {
	return global.document.querySelector('.garmin-container');
}

function findGarminKudosButtons() {
	return global.document.querySelectorAll('.garmin-kudos-button');
}

function createGarminButton() {
	return global.document.createElement('button');
}

function garminKudoAllHandler(event, findButtons) {
	event.preventDefault();
	const buttons = findButtons();
	if (buttons && buttons.length > 0) {
		buttons.forEach(button => button.click());
	}
}

function executeGarmin() {
	const container = getGarminContainer();
	const button = createGarminButton();
	button.addEventListener('click', (event) => garminKudoAllHandler(event, findGarminKudosButtons));
	container.append(button);
}

function garminConnectStandBy() {
	const observer = new MutationObserver(() => {
		executeGarmin();
	});
	observer.observe(global.document.body, { childList: true, subtree: true });
}

function isHostStrava() {
	return global.window.location.hostname === 'www.strava.com';
}

function isHostGarmin() {
	return global.window.location.hostname === 'connect.garmin.com';
}

describe('KudoAll-Strava-Garmin.user.js', () => {
	let sandbox;

	beforeEach(() => {
		sandbox = sinon.createSandbox();
		global.navigator = { language: 'en' };
		global.document = {
			querySelector: sandbox.stub(),
			querySelectorAll: sandbox.stub(),
			createElement: sandbox.stub().returns({ addEventListener: sandbox.stub() }),
			body: {
				appendChild: sandbox.stub(),
			},
		};
		global.window = {
			location: {
				hostname: 'www.strava.com',
				pathname: '/modern/newsfeed',
			},
			onload: null,
		};
		global.findStravaKudosButtons = findStravaKudosButtons;
		global.getStravaContainer = getStravaContainer;
		global.stravaStandBy = stravaStandBy;
		global.findGarminKudosButtons = findGarminKudosButtons;
		global.getGarminContainer = getGarminContainer;
		global.garminConnectStandBy = garminConnectStandBy;
		global.createStravaButton = createStravaButton;
		global.createGarminButton = createGarminButton;
		global.MutationObserver = class {
			observe() {}
		};
		global.document.querySelector.withArgs('.strava-container').returns({ prepend: sandbox.stub() });
		global.document.querySelector.withArgs('.garmin-container').returns({ append: sandbox.stub() });
	});

	afterEach(() => {
		sandbox.restore();
		delete global.findStravaKudosButtons;
		delete global.getStravaContainer;
		delete global.stravaStandBy;
		delete global.findGarminKudosButtons;
		delete global.getGarminContainer;
		delete global.garminConnectStandBy;
		delete global.createStravaButton;
		delete global.createGarminButton;
		delete global.MutationObserver;
	});

	describe('getMessage', () => {
		it('should return the correct message for the given language', () => {
			const message = getMessage('kudo_all');
			expect(message).to.equal('Kudo All');
		});

		it('should return the default message if the language is not supported', () => {
			global.navigator.language = 'xx';
			const message = getMessage('kudo_all');
			expect(message).to.equal('Kudo All');
		});
	});

	describe('Strava', () => {
		describe('getStravaContainer', () => {
			it('should return the Strava container element', () => {
				const container = { prepend: sandbox.stub() };
				global.document.querySelector.withArgs('.strava-container').returns(container);
				const result = getStravaContainer();
				expect(result).to.equal(container);
			});
		});

		describe('findStravaKudosButtons', () => {
			it('should return an array of kudos buttons', () => {
				const buttons = [{}];
				global.document.querySelectorAll.withArgs('.strava-kudos-button').returns(buttons);
				const result = findStravaKudosButtons();
				expect(result).to.deep.equal(buttons);
			});
		});

		describe('createStravaButton', () => {
			it('should create and return a Strava button element', () => {
				const button = { addEventListener: sandbox.stub() };
				global.document.createElement.withArgs('button').returns(button);
				const result = createStravaButton();
				expect(result).to.equal(button);
			});
		});

		describe('stravaKudoAllHandler', () => {
			it('should click all kudos buttons', () => {
				const event = { preventDefault: sandbox.stub() };
				const buttons = [{ parentElement: { click: sandbox.stub() } }];
				sandbox.stub(global, 'findStravaKudosButtons').returns(buttons);
				stravaKudoAllHandler(event, global.findStravaKudosButtons);
				expect(event.preventDefault.calledOnce).to.equal(true);
				expect(buttons[0].parentElement.click.calledOnce).to.equal(true);
			});
		});

		describe('stravaStandBy', () => {
			it('should create and prepend the Kudo All button', () => {
				const container = { prepend: sandbox.stub() };
				const button = { addEventListener: sandbox.stub() };
				sandbox.stub(global, 'getStravaContainer').returns(container);
				sandbox.stub(global, 'createStravaButton').returns(button);
				stravaStandBy();
				expect(container.prepend.calledOnceWith(button)).to.equal(true);
			});

			it('should add click event listener to the button', () => {
				const container = { prepend: sandbox.stub() };
				const button = { addEventListener: sandbox.stub() };
				sandbox.stub(global, 'getStravaContainer').returns(container);
				sandbox.stub(global, 'createStravaButton').returns(button);
				stravaStandBy();
				expect(button.addEventListener.calledOnceWith('click', sinon.match.func)).to.equal(true);
			});

			it('should call findStravaKudosButtons when button is clicked', () => {
				const container = { prepend: sandbox.stub() };
				const button = { addEventListener: sandbox.stub() };
				sandbox.stub(global, 'getStravaContainer').returns(container);
				sandbox.stub(global, 'createStravaButton').returns(button);
				const findStravaKudosButtonsStub = sandbox.stub(global, 'findStravaKudosButtons');
				stravaStandBy();
				expect(button.addEventListener.calledOnce).to.equal(true);
				const clickHandler = button.addEventListener.getCall(0).args[1];
				clickHandler({ preventDefault: () => {} });
				expect(findStravaKudosButtonsStub.calledOnce).to.equal(true);
			});
		});
	});

	describe('GC', () => {
		describe('getGarminContainer', () => {
			it('should return the Garmin container element', () => {
				const container = { append: sandbox.stub() };
				global.document.querySelector.withArgs('.garmin-container').returns(container);
				const result = getGarminContainer();
				expect(result).to.equal(container);
			});
		});

		describe('findGarminKudosButtons', () => {
			it('should return an array of kudos buttons', () => {
				const buttons = [{}];
				global.document.querySelectorAll.withArgs('.garmin-kudos-button').returns(buttons);
				const result = findGarminKudosButtons();
				expect(result).to.deep.equal(buttons);
			});
		});

		describe('createGarminButton', () => {
			it('should create and return a Garmin button element', () => {
				const button = { addEventListener: sandbox.stub() };
				global.document.createElement.withArgs('button').returns(button);
				const result = createGarminButton();
				expect(result).to.equal(button);
			});
		});

		describe('garminKudoAllHandler', () => {
			it('should click all kudos buttons', () => {
				const event = { preventDefault: sandbox.stub() };
				const buttons = [{ click: sandbox.stub() }];
				sandbox.stub(global, 'findGarminKudosButtons').returns(buttons);
				garminKudoAllHandler(event, global.findGarminKudosButtons);
				expect(event.preventDefault.calledOnce).to.equal(true);
				expect(buttons[0].click.calledOnce).to.equal(true);
			});
		});

		describe('executeGarmin', () => {
			it('should create and append the Kudo All button', () => {
				const container = { append: sandbox.stub() };
				const button = { addEventListener: sandbox.stub() };
				sandbox.stub(global, 'getGarminContainer').returns(container);
				sandbox.stub(global, 'createGarminButton').returns(button);
				executeGarmin();
				expect(container.append.calledOnceWith(button)).to.equal(true);
				expect(button.addEventListener.calledOnceWith('click', sinon.match.func)).to.equal(true);
			});
		});

		describe('garminConnectStandBy', () => {
			it('should observe the DOM and execute Garmin logic when the target element is loaded', () => {
				const observer = { observe: sandbox.stub() };
				sandbox.stub(global, 'MutationObserver').returns(observer);
				garminConnectStandBy();
				expect(observer.observe.calledOnce).to.equal(true);
			});
		});
	});

	describe('Host Checks', () => {
		describe('isHostStrava', () => {
			it('should return true if the hostname matches Strava', () => {
				global.window.location.hostname = 'www.strava.com';
				const result = isHostStrava();
				expect(result).to.equal(true);
			});

			it('should return false if the hostname does not match Strava', () => {
				global.window.location.hostname = 'www.example.com';
				const result = isHostStrava();
				expect(result).to.equal(false);
			});
		});

		describe('isHostGarmin', () => {
			it('should return true if the hostname matches Garmin', () => {
				global.window.location.hostname = 'connect.garmin.com';
				const result = isHostGarmin();
				expect(result).to.equal(true);
			});

			it('should return false if the hostname does not match Garmin', () => {
				global.window.location.hostname = 'www.example.com';
				const result = isHostGarmin();
				expect(result).to.equal(false);
			});
		});
	});

	describe('Initialization', () => {
		it('should initiate Strava standby if the host is Strava', () => {
			global.window.location.hostname = 'www.strava.com';
			const stravaStandByStub = sandbox.stub(global, 'stravaStandBy');
			global.window.onload = () => {
				if (isHostStrava()) {
					stravaStandBy();
				}
			};
			global.window.onload();
			expect(stravaStandByStub.calledOnce).to.equal(true);
		});

		it('should initiate Garmin standby if the host is Garmin', () => {
			global.window.location.hostname = 'connect.garmin.com';
			const garminConnectStandByStub = sandbox.stub(global, 'garminConnectStandBy');
			global.window.onload = () => {
				if (isHostGarmin()) {
					garminConnectStandBy();
				}
			};
			global.window.onload();
			expect(garminConnectStandByStub.calledOnce).to.equal(true);
		});

		it('should not perform any actions if the host is not recognized', () => {
			global.window.location.hostname = 'www.example.com';
			const stravaStandByStub = sandbox.stub(global, 'stravaStandBy');
			const garminConnectStandByStub = sandbox.stub(global, 'garminConnectStandBy');
			global.window.onload = () => {
				if (isHostStrava()) {
					stravaStandBy();
				} else if (isHostGarmin()) {
					garminConnectStandBy();
				}
			};
			global.window.onload();
			expect(stravaStandByStub.called).to.equal(false);
			expect(garminConnectStandByStub.called).to.equal(false);
		});
	});
});
