const counter = document.getElementById("counter-number");
function updateCounter() {
	fetch("https://jfskn2tmpce67sghwofcf2gc6u0qrwtb.lambda-url.ap-southeast-2.on.aws/")
    .then((response) => response.json())
    .then((data) => {
         counter.innerHTML = `Views: ${data}`
    });
}
updateCounter();
