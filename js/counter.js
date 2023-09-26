const counter = document.getElementById("counter-number");
async function updateCounter() {
	let response = fetch("");
	let data = await response.json();
	counter.innerHTML = `Views: ${data}`;
}
updateCounter();

