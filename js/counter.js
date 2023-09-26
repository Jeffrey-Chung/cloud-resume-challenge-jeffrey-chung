const counter = document.getElementById("counter-number");
fetch("https://u2iduptl7jfxpo5ny4u637g4pm0iqytg.lambda-url.ap-southeast-2.on.aws/")
    .then((response) => JSON.parse(response.json()))
    .then((data) => {
         counter.innerHTML = `Views: ${data}`
    }); 


