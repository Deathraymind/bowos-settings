const { invoke } = window.__TAURI__.core;

let greetInputEl;
let greetMsgEl;

async function greet() {
  // Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
  greetMsgEl.textContent = await invoke("set_wallpaper", { name: greetInputEl.value });
}

window.addEventListener("DOMContentLoaded", () => {
  // Fix the element ID here to match your HTML
  greetInputEl = document.querySelector("#wallpaper-directory");
  greetMsgEl = document.querySelector("#confirmation");

  // Attach event listener to the correct form (wallpaper-settings)
  document.querySelector("#wallpaper-settings").addEventListener("submit", (e) => {
    e.preventDefault();
    greet();
  });
});

