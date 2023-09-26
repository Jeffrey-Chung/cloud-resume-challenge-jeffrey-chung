const counter = document.getElementById("counter-number");
async function updateCounter() {
    try {
        const response = await fetch('');
    
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

