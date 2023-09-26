const counter = document.getElementById("counter-number");
async function updateCounter() {
	let response = fetch("https://i3tiofgzuvahp7vhqovoxt4gvu0sibep.lambda-url.ap-southeast-2.on.aws/");
	let data = await response.json();
	counter.innerHTML = `Views: ${data}`;
}
updateCounter();

