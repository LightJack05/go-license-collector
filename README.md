# Go License Collector

A tool to automatically detect and save licenses of all Go dependencies into the `LICENSES/` directory of your Go project.

> [!CAUTION]
> THIS TOOL IS AI GENERATED
> While I have tested it, read through the code and am using it myself, I do not guarantee anything about this tool.
> It seems to work quite well and appears like it is somewhat stable, but if it blows up, it blows up.

## Features

- 🔍 Automatically discovers all Go module dependencies
- 📄 Extracts license files from each dependency
- 📁 Organizes licenses in a structured `LICENSES/` directory
- ⚡ Smart caching - only updates licenses when they change
- ✅ Detects common license file names (LICENSE, LICENSE.txt, LICENSE.md, COPYING, etc.)

## Prerequisites

- **Go**: A working Go installation is required
- **Bash**: The script runs in bash
- **Nix** (optional): Required only if using the Nix flake method

## Usage

### Method 1: Using as a Nix Flake (Recommended)

The easiest way to use this tool is via the Nix flake. This method automatically handles all dependencies.

#### One-time execution

Run the tool directly in your Go project directory:

```bash
nix run github:LightJack05/go-license-collector
```

#### Add to your project's flake

You can integrate this tool into your own Nix flake:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    go-license-collector.url = "github:LightJack05/go-license-collector";
  };

  outputs = { self, nixpkgs, go-license-collector }:
    let
      system = "x86_64-linux";  # or your system
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          go-license-collector.packages.${system}.go-license-collector
        ];
      };
    };
}
```

Then run it in your dev shell:

```bash
nix develop
go-license-collector
```

### Method 2: Using as a Bare Shell Script

If you prefer not to use Nix, you can run the script directly.

#### Download and run

```bash
# Download the script
curl -O https://raw.githubusercontent.com/LightJack05/go-license-collector/main/go-license-collector.sh

# Make it executable
chmod +x go-license-collector.sh

# Run it in your Go project directory
./go-license-collector.sh
```

#### Install globally

To install the script for system-wide use:

```bash
# Download the script
curl -o /usr/local/bin/go-license-collector https://raw.githubusercontent.com/LightJack05/go-license-collector/main/go-license-collector.sh

# Make it executable
chmod +x /usr/local/bin/go-license-collector

# Run from anywhere in your Go projects
cd /path/to/your/go/project
go-license-collector
```

## How It Works

1. The tool runs `go mod download` to ensure all dependencies are available
2. It uses `go list -m all` to enumerate all modules in your project
3. For each module, it searches for common license file names
4. Licenses are copied to `LICENSES/<module-path>/<license-filename>`
5. Existing licenses are only updated if they differ from the source

## Output

The tool provides informative output for each dependency:

- `✓ module/path` - License successfully collected
- `↻ module/path (updated license)` - License was updated
- `⊙ module/path (already up to date)` - License unchanged
- `⚠️ No license found for module/path` - No license file detected

## Example

Running the tool in a Go project:

```bash
$ go-license-collector
Downloading modules (if needed)…
Collecting licenses…
✓ github.com/google/uuid
✓ golang.org/x/text
⊙ github.com/stretchr/testify (already up to date)
⚠️  No license found for example.com/private-module
```

After execution, you'll find a `LICENSES/` directory structure like:

```
LICENSES/
├── github.com/
│   ├── google/
│   │   └── uuid/
│   │       └── LICENSE
│   └── stretchr/
│       └── testify/
│           └── LICENSE
└── golang.org/
    └── x/
        └── text/
            └── LICENSE
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
