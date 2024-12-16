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

// Generate bike gallery
async function generateGallery() {
    const { wheels, frames, bikes } = await getZwiftData();
    const gallery = document.getElementById('bikeGallery');
    gallery.innerHTML = '';

    for (const bike of bikes) {
        const frame = frames.find(f => f.frameid === bike.frameid);
        const wheel = wheels.find(w => w.wheelid === bike.wheelid);

        if (frame && wheel) {
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
                    <p><strong>Flat Performance:</strong> ${frame.frameflatnumber} | ${wheel.wheelflatnumber}</p>
                    <p><strong>Climb Performance:</strong> ${frame.frameclimbnumber} | ${wheel.wheelclimbnumber}</p>
                </div>
            `;
            gallery.appendChild(bikeCard);
        }
    }
}

// Generate the gallery on page load
document.addEventListener('DOMContentLoaded', generateGallery);
