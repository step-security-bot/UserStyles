// Fetch data from JSON files
async function fetchData(file) {
    const response = await fetch(file);
    const data = await response.json();
    return data;
}

// Fetch wheels, frames, and bikes data
async function getZwiftData() {
    const wheels = await fetchData('wheels.json');
    const frames = await fetchData('frames.json');
    const bikes = await fetchData('bikes.json');
    return { wheels, frames, bikes };
}

// Generate bike gallery with sorting
async function generateGallery() {
    const { wheels, frames, bikes } = await getZwiftData();
    const gallery = document.getElementById('bikeGallery');
    const sortCriteria = document.getElementById('sortCriteria').value;

    // Calculate performance for each bike
    const bikePerformances = bikes.map(bike => {
        const frame = frames.find(f => f.frameid === bike.frameid);
        const wheel = wheels.find(w => w.wheelid === bike.wheelid);

        if (frame && wheel) {
            const flatNumber = (parseFloat(frame.frameflatnumber) + parseFloat(wheel.wheelflatnumber)) / 2;
            const climbNumber = (parseFloat(frame.frameclimbnumber) + parseFloat(wheel.wheelclimbnumber)) / 2;

            return {
                bike: bike,
                frame: frame,
                wheel: wheel,
                flatNumber: flatNumber,
                climbNumber: climbNumber
            };
        }
        return null;
    }).filter(bikePerformance => bikePerformance !== null);

    // Sort the bikes based on the selected criteria
    if (sortCriteria === 'flatBest') {
        bikePerformances.sort((a, b) => b.flatNumber - a.flatNumber);
    } else if (sortCriteria === 'flatWorst') {
        bikePerformances.sort((a, b) => a.flatNumber - b.flatNumber);
    } else if (sortCriteria === 'climbBest') {
        bikePerformances.sort((a, b) => b.climbNumber - a.climbNumber);
    } else if (sortCriteria === 'climbWorst') {
        bikePerformances.sort((a, b) => a.climbNumber - b.climbNumber);
    }

    // Generate the gallery
    gallery.innerHTML = '';
    for (const bikePerformance of bikePerformances) {
        const { frame, wheel, flatNumber, climbNumber } = bikePerformance;
        const bikeCard = document.createElement('div');
        bikeCard.className = 'bike-card';
        bikeCard.innerHTML = `
            <img src="${frame.frameimg}" alt="${frame.framemake} ${frame.framemodel}">
            <div class="bike-details">
                <h3>${frame.framemake} ${frame.framemodel}</h3>
                <p><strong>Wheel:</strong> ${wheel.wheelmake} ${wheel.wheelmodel}</p>
                <img src="${wheel.wheelimg}" alt="${wheel.wheelmake} ${wheel.wheelmodel}">
                <p><strong>Price:</strong> ${frame.frameprice} + ${wheel.wheelprice}</p>
                <p><strong>Level:</strong> ${frame.framelevel} | ${wheel.wheellevel}</p>
                <p><strong>Flat Performance:</strong> ${flatNumber.toFixed(2)}</p>
                <p><strong>Climb Performance:</strong> ${climbNumber.toFixed(2)}</p>
            </div>
        `;
        gallery.appendChild(bikeCard);
    }
}

// Generate the gallery on page load
document.addEventListener('DOMContentLoaded', generateGallery);
