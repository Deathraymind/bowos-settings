const { invoke } = window.__TAURI__.core;
// bro i spent way too long to use this instead of use idk why the docs are so outdated 

let wallpaperInput;
let hyperFilePath;
//these define some variables i reused


async function selectWallpaper() {
  // Calls the Rust function "select_wallpaper" with no parameters
  await invoke("select_wallpaper");
  console.log("Wallpaper selection function called");
}

async function selectLockscreen() {
  // Calls the Rust function "select_wallpaper" with no parameters
  await invoke("select_lockscreen");
  console.log("Lock wallpaper selection function called");
}


window.addEventListener("DOMContentLoaded", () => {

  wallpaperInput = document.querySelector("#wallpaper-directory");
  hyperFilePath = document.querySelector("#confirmation");

document.getElementById("select-file-button").addEventListener("click", selectWallpaper);
document.getElementById("select-lockscreen").addEventListener("click", selectLockscreen);
// this calls the selectWallpaper process above when the button is clicked

  // Attach event listener to the correct form (wallpaper-settings)
  document.querySelector("#wallpaper-settings").addEventListener("submit", (e) => {
    e.preventDefault();
    setWallpaper();
  });
});

