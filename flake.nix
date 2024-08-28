{
  inputs = {
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      crane,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        craneLib = crane.mkLib pkgs;
        cargoArtifacts = craneLib.buildDepsOnly {
          src = craneLib.cleanCargoSource (craneLib.path ./.);
        };
      in
      {
        packages.default = cargoArtifacts;
      }
    );
}
