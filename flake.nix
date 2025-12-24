{
  description = "Collect Go dependency licenses into a LICENSES directory";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          go-license-collector = pkgs.writeShellApplication {
            name = "go-license-collector";
            runtimeInputs = with pkgs; [ bash go coreutils ];
            text = builtins.readFile ./go-license-collector.sh;
          };
        });

      apps = forAllSystems (system: {
        go-license-collector = {
          type = "app";
          program = "${self.packages.${system}.go-license-collector}/bin/go-license-collector";
        };
      });

      defaultPackage = forAllSystems (system:
        self.packages.${system}.go-license-collector
      );
    };
}
