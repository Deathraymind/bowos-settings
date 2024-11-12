use std::fs::{self, write};
use std::path::Path;
use std::env;
use std::process::{Command, Stdio};
use rfd::FileDialog;


#[tauri::command]
fn set_wallpaper(name: &str) -> String {
    let user_name = env::var("USER").unwrap_or_else(|_| "default_user".to_string());
    let dir_path = format!("/home/{}/bowos/wallpaper", user_name);

    if let Err(_) = fs::create_dir_all(&dir_path) {
        return "Failed to create directory.".to_string();
    }

    let file_path = format!("{}/hyprpaper.conf", dir_path);
    let file_content = format!("preload = {}\nwallpaper = , {}", name, name);
    if let Err(_) = write(&file_path, file_content) {
        return "Failed to write to file.".to_string();
    }

    // Terminate any existing instance of hyprpaper
    let _ = Command::new("pkill")
        .arg("hyprpaper")
        .status();

    // Start hyprpaper in the background and handle it properly
    if let Ok(mut child) = Command::new("hyprpaper")
        .arg("-c")
        .arg(&file_path)
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .spawn()
    {
        // Use .wait() to immediately reap the child process
        std::thread::spawn(move || {
            let _ = child.wait();
        });
        format!("Wallpaper set with config file '{}'", file_path)
    } else {
        "Failed to start hyprpaper.".to_string()
    }
}


#[tauri::command]
fn select_wallpaper() -> String {
    let user_name = env::var("USER").unwrap_or_else(|_| "default_user".to_string());
    let dir_path = format!("/home/{}", user_name);
    let files = FileDialog::new()
        .set_directory(dir_path)
        .pick_files();

    if let Some(paths) = files {
        for path in paths {
            println!("Selected file: {:?}", path);
            let wallpaperdir = path.into_os_string().into_string().unwrap();
            set_wallpaper(&wallpaperdir);
        }
    }

    
    "Wallpaper selection executed".to_string() // Example return value
}



#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_shell::init())
        .invoke_handler(tauri::generate_handler![set_wallpaper, select_wallpaper])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
