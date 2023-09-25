require('dotenv').config()

const counter = document.getElementsByClassName("counter-number");
async function updateCounter() {
	let response = fetch("https://3jdv3fjamvarshhthnvpfgg2ii0wnoun.lambda-url.ap-southeast-2.on.aws/");
	let data = await response.json();
	counter.innerHTML = `Views: ${data}`;
}
updateCounter();