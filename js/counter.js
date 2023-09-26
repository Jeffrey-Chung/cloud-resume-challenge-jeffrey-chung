const counter = document.getElementById("counter-number");
fetch("https://tha2jdndljtvktr6tj3253nnrm0rflxa.lambda-url.ap-southeast-2.on.aws/")
    .then((response) => response.json())
    .then((data) => {
         counter.innerHTML = `Views: ${data}`
    }); 


