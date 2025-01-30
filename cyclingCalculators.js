/* eslint-disable @typescript-eslint/no-unused-vars */
function calculateSpeed() {
	const distance = parseFloat(document.getElementById('distance').value);
	const time = parseFloat(document.getElementById('time').value);

	if (distance > 0 && time > 0) {
		const speed = (distance / time).toFixed(2);
		document.getElementById('speedResult').innerText = `Speed: ${speed} km/h`;
	} else {
		alert('Please enter valid values for distance and time.');
	}
}

function calculatePower() {
	const weight = parseFloat(document.getElementById('weight').value);
	const speed = parseFloat(document.getElementById('cyclistSpeed').value);

	if (weight > 0 && speed > 0) {
		const power = (weight * speed * 0.2).toFixed(2); // Simplified power calculation
		document.getElementById('powerResult').innerText = `Power: ${power} Watts`;
	} else {
		alert('Please enter valid values for weight and speed.');
	}
}

function calculateCalories() {
	const weight = parseFloat(document.getElementById('weightCalories').value);
	const duration = parseFloat(document.getElementById('duration').value);

	if (weight > 0 && duration > 0) {
		const metValue = 8; // MET value for moderate cycling
		const calories = (metValue * weight * duration).toFixed(2);
		document.getElementById('caloriesResult').innerText =
			`Calories burned: ${calories} kcal`;
	} else {
		alert('Please enter valid values for weight and duration.');
	}
}

function calculateCadence() {
	const revolutions = parseFloat(document.getElementById('revolutions').value);
	const time = parseFloat(document.getElementById('timeCadence').value);

	if (revolutions > 0 && time > 0) {
		const cadence = (revolutions / time).toFixed(2);
		document.getElementById('cadenceResult').innerText =
			`Cadence: ${cadence} RPM (Revolutions per Minute)`;
	} else {
		alert('Please enter valid values for revolutions and time.');
	}
}

function calculateDistance() {
	const time = parseFloat(document.getElementById('timeDistance').value);
	const speed = parseFloat(document.getElementById('speedDistance').value);

	if (time > 0 && speed > 0) {
		const distance = (time * speed).toFixed(2);
		document.getElementById('distanceResult').innerText =
			`Distance: ${distance} km`;
	} else {
		alert('Please enter valid values for time and speed.');
	}
}

function convertDistance() {
	const distance = parseFloat(document.getElementById('distanceInput').value);
	const conversionType = document.getElementById('conversionType').value;

	if (distance > 0) {
		let convertedDistance;
		if (conversionType === 'kmToMiles') {
			convertedDistance = (distance * 0.621371).toFixed(2);
			document.getElementById('conversionResult').innerText =
				`${distance} KM is equal to ${convertedDistance} Miles`;
		} else if (conversionType === 'milesToKm') {
			convertedDistance = (distance / 0.621371).toFixed(2);
			document.getElementById('conversionResult').innerText =
				`${distance} Miles is equal to ${convertedDistance} KM`;
		}
	} else {
		alert('Please enter a valid distance.');
	}
}

function calculateAverageSpeed() {
	const totalDistance = parseFloat(
		document.getElementById('totalDistance').value,
	);
	const totalTime = parseFloat(document.getElementById('totalTime').value);

	if (totalDistance > 0 && totalTime > 0) {
		const averageSpeed = (totalDistance / totalTime).toFixed(2);
		document.getElementById('averageSpeedResult').innerText =
			`Average Speed: ${averageSpeed} km/h`;
	} else {
		alert('Please enter valid values for total distance and total time.');
	}
}

function calculateClimbingSpeed() {
	const distance = parseFloat(document.getElementById('climbDistance').value);
	const gradient = parseFloat(document.getElementById('gradient').value);
	const power = parseFloat(document.getElementById('powerClimbing').value);

	if (distance > 0 && gradient > 0 && power > 0) {
		const speed = (power / (gradient * distance)).toFixed(2); // Simplified calculation
		document.getElementById('climbingSpeedResult').innerText =
			`Climbing Speed: ${speed} km/h`;
	} else {
		alert('Please enter valid values for distance, gradient, and power.');
	}
}

function calculateGearRatio() {
	const chainring = parseFloat(document.getElementById('chainring').value);
	const cog = parseFloat(document.getElementById('cog').value);

	if (chainring > 0 && cog > 0) {
		const ratio = (chainring / cog).toFixed(2);
		document.getElementById('gearRatioResult').innerText =
			`Gear Ratio: ${ratio}`;
	} else {
		alert('Please enter valid values for chainring and cog.');
	}
}

function calculateHeartRateZones() {
	const maxHeartRate = parseFloat(
		document.getElementById('maxHeartRate').value,
	);

	if (maxHeartRate > 0) {
		const zones = {
			zone1:
				(maxHeartRate * 0.5).toFixed(0) +
				' - ' +
				(maxHeartRate * 0.6).toFixed(0) +
				' bpm',
			zone2:
				(maxHeartRate * 0.6).toFixed(0) +
				' - ' +
				(maxHeartRate * 0.7).toFixed(0) +
				' bpm',
			zone3:
				(maxHeartRate * 0.7).toFixed(0) +
				' - ' +
				(maxHeartRate * 0.8).toFixed(0) +
				' bpm',
			zone4:
				(maxHeartRate * 0.8).toFixed(0) +
				' - ' +
				(maxHeartRate * 0.9).toFixed(0) +
				' bpm',
			zone5:
				(maxHeartRate * 0.9).toFixed(0) +
				' - ' +
				maxHeartRate.toFixed(0) +
				' bpm',
		};

		document.getElementById('heartRateZonesResult').innerHTML = `
            <p>Zone 1: ${zones.zone1}</p>
            <p>Zone 2: ${zones.zone2}</p>
            <p>Zone 3: ${zones.zone3}</p>
            <p>Zone 4: ${zones.zone4}</p>
            <p>Zone 5: ${zones.zone5}</p>
        `;
	} else {
		alert('Please enter a valid value for max heart rate.');
	}
}

function estimateVO2Max() {
	const weight = parseFloat(document.getElementById('vo2MaxWeight').value);
	const speed = parseFloat(document.getElementById('vo2MaxSpeed').value);

	if (weight > 0 && speed > 0) {
		const vo2Max = (speed / weight).toFixed(2); // Simplified calculation
		document.getElementById('vo2MaxResult').innerText =
			`Estimated VO2 Max: ${vo2Max} mL/kg/min`;
	} else {
		alert('Please enter valid values for weight and speed.');
	}
}

function calculateElapsedTime() {
	const startTime = document.getElementById('startTime').value;
	const endTime = document.getElementById('endTime').value;

	if (startTime && endTime) {
		const start = new Date('1970-01-01T' + startTime + 'Z');
		const end = new Date('1970-01-01T' + endTime + 'Z');
		const elapsed = (end - start) / 1000 / 60 / 60; // in hours

		if (elapsed > 0) {
			document.getElementById('elapsedTimeResult').innerText =
				`Elapsed Time: ${elapsed.toFixed(2)} hours`;
		} else {
			alert('End time must be later than start time.');
		}
	} else {
		alert('Please enter valid start and end times.');
	}
}

function calculateWeightImpact() {
	const riderWeight = parseFloat(document.getElementById('riderWeight').value);
	const bikeWeight = parseFloat(document.getElementById('bikeWeight').value);
	const slope = parseFloat(document.getElementById('slope').value);

	if (riderWeight > 0 && bikeWeight > 0 && slope > 0) {
		const impact = ((riderWeight + bikeWeight) * slope) / 100; // Simplified calculation
		document.getElementById('weightImpactResult').innerText =
			`Weight Impact: ${impact.toFixed(2)} kg`;
	} else {
		alert(
			'Please enter valid values for rider weight, bike weight, and slope.',
		);
	}
}

function calculateWindResistance() {
	const windSpeed = parseFloat(document.getElementById('windSpeed').value);
	const cyclingSpeed = parseFloat(
		document.getElementById('cyclingSpeed').value,
	);

	if (windSpeed > 0 && cyclingSpeed > 0) {
		const resistance = (cyclingSpeed + windSpeed).toFixed(2); // Simplified calculation
		document.getElementById('windResistanceResult').innerText =
			`Wind Resistance: ${resistance} km/h`;
	} else {
		alert('Please enter valid values for wind speed and cycling speed.');
	}
}

function calculateRollingResistance() {
	const rollingCoefficient = parseFloat(
		document.getElementById('rollingCoefficient').value,
	);
	const weight = parseFloat(document.getElementById('weightRolling').value);

	if (rollingCoefficient > 0 && weight > 0) {
		const resistance = (rollingCoefficient * weight).toFixed(2);
		document.getElementById('rollingResistanceResult').innerText =
			`Rolling Resistance: ${resistance} kg`;
	} else {
		alert(
			'Please enter valid values for rolling resistance coefficient and weight.',
		);
	}
}

function calculateCadenceAndGear() {
	const cadence = parseFloat(document.getElementById('cadenceGear').value);
	const wheelDiameter = parseFloat(
		document.getElementById('wheelDiameter').value,
	);

	if (cadence > 0 && wheelDiameter > 0) {
		const speed = (cadence * wheelDiameter * 0.002).toFixed(2); // Simplified calculation
		document.getElementById('cadenceGearResult').innerText =
			`Speed: ${speed} km/h`;
	} else {
		alert('Please enter valid values for cadence and wheel diameter.');
	}
}
