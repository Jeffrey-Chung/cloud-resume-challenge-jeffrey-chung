const counter = document.getElementById("counter-number");
fetch("")
    .then((response) => response.json())
    .then((data) => {
         counter.innerHTML = `Views: ${data}`
    }); 


