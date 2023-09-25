import dotenv from 'dotenv'
dotenv.config();

const counter = document.getElementById("counter-number");
async function updateCounter() {
	fetch(process.env.LAMBDA_URL)
    .then((response) => response.json())
    .then((data) => {
         counter.innerHTML = `Views: ${data}`
    });
   
}
updateCounter();