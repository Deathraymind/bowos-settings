
# BowOS Settings

BowOS Settings is a Rust + Tauri application designed to make managing settings like wallpapers and other configuration tasks quick and seamless. While the app simplifies everyday settings, familiarity with NixOS configuration files is important since the app integrates with your existing configurations.

---

## Recommended IDE Setup

To develop in this environment, there is a simple Nix flake you can use. Follow these steps to set up the development environment:

1. Navigate to the `nixos` directory:
   ```bash
   cd nixos
   ```

2. Start the development environment:
   ```bash
   nix develop
   ```

3. Head back to the root directory to run the Tauri development script:
   ```bash
   cd ..
   ```

4. Run the Tauri development server:
   ```bash
   cargo tauri dev
   ```

You can now edit the code, and changes will reflect on the fly.

---

## Creating a NixOS Binary

### Provided Nix Configurations

1. **`remote.nix`**:  
   This file allows you to pull the project directly from the GitHub repository and build it. However, this method is not typically recommended—it’s mainly for convenience or testing.

2. **`local.nix`**:  
   Designed to build from local files, the `src` attribute is set to `./.`. This means it will reference the `Cargo.toml` file located in the same directory to build the project.

3. **`default.nix`**:  
   Generated using the following commands:
   ```bash
   nix run github:nix-community/nix-init
   ```
   Followed by:
   ```bash
   nix-init
   ```
   This creates a `default.nix` or `package.nix` file capable of building the project directly from the GitHub repository. It's an amazing feature! Since this is a Rust application, remember to set the `rustbuild` option when prompted during initialization.

---

### Testing Dependencies

To ensure all dependencies are in place, run the following command:
```bash
nix-build -E "(import <nixpkgs> {}).callPackage ./. {}"
```

This will generate the binary in the `result` directory. It's a simple and effective way to verify the build process.

# Making it a Package

We have the binary and it successfully compiled but we need to output it to our nix-env on our entire system, this is simple. I have created a package.nix which looks fairly simple because it is. It just helps make the default. nix compilable on our system as a flake or normal nix config file. So if we run the command. 

```bash
nix-env -i -f package.nix
```

now we can run bowos-settings from anywhere on our system!!!


