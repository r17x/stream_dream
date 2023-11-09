{
  description = "Memulai Dream";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nix-ocaml/nix-overlays";

    # Depend on the Melange flake, which provides the overlay
    melange-nix.url = "github:melange-re/melange";
    melange-nix.inputs.nixpkgs.follows = "nixpkgs";

    server-reason-react-repo.url = "github:ml-in-barcelona/server-reason-react";
    server-reason-react-repo.flake = false;
  };

  outputs = { nixpkgs, utils, melange-nix, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.appendOverlays [
          # Set the OCaml set of packages to the 5.1 release line
          (self: super: {
            ocamlPackages = super.ocaml-ng.ocamlPackages_5_1.overrideScope' (
              oself: osuper: {
                reason = osuper.reason.overrideAttrs (o: {
                  patches = [ ];
                });

                melange = osuper.melange.overrideAttrs (o: {
                  src = super.fetchFromGitHub {
                    owner = "melange-re";
                    repo = "melange";
                    rev = "a01735398b5df5b90f0a567dd660847ae0e9da48";
                    hash = "sha256-2/CyjNmOQCIq9OZzf+r4yaQpXd+VQQ6MWQyJAn9cOqo=";
                    fetchSubmodules = true;
                  };
                });

                # server-reason-react = buildDunePackage {
                #   name = "server-reason-react";
                #   pname = "server-reason-react";
                #   version = "0.1.0";
                #   duneVersion = "3";
                #   minimalOCamlVersion = "5.1";
                #   src = server-reason-react-repo;
                #   strictDeps = true;
                #   nativeBuildInputs = [
                #     findlib
                #     ocaml-lsp
                #     reason
                #     reason-native.refmterr
                #     ocamlformat
                #   ];
                #   buildInputs = [
                #     alcotest
                #     alcotest-lwt
                #     dream
                #     fmt
                #     lwt
                #     lwt_ppx
                #     melange-webapi
                #     melange
                #     ocaml_pcre
                #     ppxlib
                #     reason-react
                #     uri
                #   ];
                # };
              }
            );
          })
          # Apply the Melange overlay
          melange-nix.overlays.default
        ];
        inherit (pkgs) ocamlPackages;
      in

      {
        devShells.default = with ocamlPackages; pkgs.mkShell {
          nativeBuildInputs = [
            ocaml
            dune_3
            findlib
            ocaml-lsp
            reason-native.refmterr
            ocamlformat
          ];
          buildInputs = [
            dream
            # server-reason-react
            # melange-webapi
            # melange
          ];
        };
      });
}
