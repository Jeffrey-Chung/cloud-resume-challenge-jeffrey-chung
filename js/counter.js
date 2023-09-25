require('dotenv').config();

const counter = document.querySelector(".content.inner.counter-number");
async function updateCounter() {
	let response = fetch(process.env.LAMBDA_URL);
	let data = await response.json();
	counter.innerHTML = `Views: ${data}`;
}
updateCounter();