const counter = document.getElementById("counter-number");
fetch("")
    .then((response) => JSON.parse(response.json()))
    .then((data) => {
         counter.innerHTML = `Views: ${data}`
    }); 


