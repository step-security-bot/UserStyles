let wheels = [];
let frames = [];
let bikes = [];

async function loadJSONData() {
    wheels = await fetch('wheels.json').then(response => response.json());
    frames = await fetch('frames.json').then(response => response.json());
    bikes = await fetch('bikes.json').then(response => response.json());
}

function calculateBestBike() {
    const speedPreference = parseFloat(document.getElementById('speedPreference').value);
    const climbPreference = parseFloat(document.getElementById('climbPreference').value);

    let bestBike = '';
    let bestBikeSpeed = 0;
    let bestBikeClimb = 0;

    for (const bike of bikes) {
        const frame = frames.find(f => f.frameid === bike.frameid);
        const wheel = wheels.find(w => w.wheelid === bike.wheelid);

        if (frame && wheel) {
            const combinedSpeed = frame.frameflatnumber + wheel.wheelflatnumber;
            const combinedClimb = frame.frameclimbnumber + wheel.wheelclimbnumber;

            if (combinedSpeed >= speedPreference && combinedClimb >= climbPreference) {
                if (combinedSpeed > bestBikeSpeed || (combinedSpeed === bestBikeSpeed && combinedClimb > bestBikeClimb)) {
                    bestBike = `${frame.framemake} ${frame.framemodel} with ${wheel.wheelmake} ${wheel.wheelmodel}`;
                    bestBikeSpeed = combinedSpeed;
                    bestBikeClimb = combinedClimb;
                }
            }
        }
    }

    document.getElementById('bestBikeResult').innerText = `Best Bike: ${bestBike}`;
}

loadJSONData();
