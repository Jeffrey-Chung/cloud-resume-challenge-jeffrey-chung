import { config } from 'dotenv';
config();

const counter = document.getElementById("counter-number");
fetch(process.env.LAMBDA_URL)
    .then((response) => response.json())
    .then((data) => {
         counter.innerHTML = `Views: ${data}`
    });
