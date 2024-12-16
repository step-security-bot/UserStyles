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
                <p><strong>Frame Make:</strong> ${frame.framemake}</p>
                <p><strong>Frame Model:</strong> ${frame.framemodel}</p>
                <p><strong>Frame Price:</strong> ${frame.frameprice}</p>
                <p><strong>Frame Level:</strong> ${frame.framelevel}</p>
                <p><strong>Frame Aero:</strong> ${frame.frameaero}</p>
                <p><strong>Frame Weight:</strong> ${frame.frameweight}</p>
                <p><strong>Frame Type:</strong> ${frame.frametype}</p>
                <p><strong>Frame Wheel Type:</strong> ${frame.framewheeltype}</p>
                <p><strong>Frame Flat Number:</strong> ${frame.frameflatnumber}</p>
                <p><strong>Frame Climb Number:</strong> ${frame.frameclimbnumber}</p>
                <p><strong>Frame Flat Rank:</strong> ${frame.frameflatrank}</p>
                <p><strong>Frame Climb Rank:</strong> ${frame.frameclimbrank}</p>
                <p><strong>Frame Article:</strong> ${frame.framearticle}</p>
                <p><strong>Frame Legacy:</strong> ${frame.framelegacy}</p>

                <img src="${wheel.wheelimg}" alt="${wheel.wheelmake} ${wheel.wheelmodel}">
                <h3>${wheel.wheelmake} ${wheel.wheelmodel}</h3>
