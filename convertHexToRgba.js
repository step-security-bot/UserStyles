document.getElementById('convertButton').addEventListener('click', () => {
    const fileInput = document.getElementById('fileInput');
    const file = fileInput.files[0];
    const opacityFormat = document.querySelector('input[name="opacityFormat"]:checked').value;

    if (file) {
        const reader = new FileReader();

        reader.onload = (e) => {
            const data = e.target.result;
            const convertedData = data.replace(/#([0-9A-Fa-f]{8})/g, (match) => hexToRgba(match, opacityFormat));

            document.getElementById('output').textContent = convertedData;
        };

        reader.readAsText(file);
    } else {
        alert('Please select a file first.');
    }
});

document.getElementById('copyButton').addEventListener('click', () => {
    const outputElement = document.getElementById('output');
    const range = document.createRange();
    range.selectNode(outputElement);
    window.getSelection().removeAllRanges();
    window.getSelection().addRange(range);

    try {
        const successful = document.execCommand('copy');
        const msg = successful ? 'successful' : 'unsuccessful';
        alert('Copying text was ' + msg);
    } catch (err) {
        console.error('Unable to copy text: ', err);
    }

    window.getSelection().removeAllRanges();
});

function hexToRgba(hex, format) {
    let r = parseInt(hex.slice(1, 3), 16);
    let g = parseInt(hex.slice(3, 5), 16);
    let b = parseInt(hex.slice(5, 7), 16);
    let a = parseInt(hex.slice(7, 9), 16) / 255;
    if (format === 'percentage') {
        a = (a * 100).toFixed(0) + '%';
    } else {
        a = a.toFixed(2);
    }
    return `rgba(${r}, ${g}, ${b}, ${a})`;
}
