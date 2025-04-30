{
  description = "A Nix flake for shmux with custom tmux configuration";

  inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs";
    flake-utils.url   = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem flake-utils.lib.allSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname   = "shmux";
          version = "1.0.0";
          src     = ./.;

          buildInputs = [ ];

          installPhase = ''
            mkdir -p $out/bin
            cp shmux          $out/bin/
            chmod +x          $out/bin/shmux

            cp _tmux.conf     $out/

            cat > $out/bin/shx <<'EOF'
            #!/usr/bin/env bash
            export SHMUX_TMUX_CONF="$(dirname "$0")/../_tmux.conf"
            exec "$(dirname "$0")/shmux" "$@"
            EOF
            chmod +x $out/bin/shx
          '';

          meta = with pkgs.lib; {
            description  = "shmux script with custom tmux configuration and shx wrapper";
            homepage     = "https://example.com/shmux";
            license      = licenses.mit;
            maintainers  = with maintainers; [ ];
            platforms    = platforms.unix;
          };
        };
      });
}
