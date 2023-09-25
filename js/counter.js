require('dotenv').config()

const counter = document.getElementsByClassName("counter-number");
console.log(process.env.LAMBDA_URL)
async function updateCounter() {
	let response = fetch(process.env.LAMBDA_URL);
	let data = await response.json();
	counter.innerHTML = `Views: ${data}`;
}
updateCounter();