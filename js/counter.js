const counter = document.getElementById("counter-number");
async function updateCounter() {
    try {
        // Insert API link here
        const response = await fetch('https://ifjmckygxdjvs5sfvfdo6vb3o40gikcx.lambda-url.ap-southeast-2.on.aws/');
    
        if (!response.ok) {
          throw new Error(`Error! status: ${response.status}`);
        }
        let data = await response.json();
        counter.innerHTML = `Views: ${data}`;
    }
    catch (err) {
        console.log(err);
      }
}
await updateCounter();

