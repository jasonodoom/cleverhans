{
  description = "A flake for building and developing on the CleverHans library.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11"; 
  };

  outputs = { self, nixpkgs }: let

   mkCleverHans = pkgs: pkgs.python3Packages.buildPythonPackage rec {
      pname = "cleverhans";
      version = "master"; 
  
      src = pkgs.fetchFromGitHub {
        owner = "jasonodoom";
        repo = "cleverhans";
        rev = "master";  
        sha256 = "sha256-ox7psBA0qqc9/J3HRNjzj1jXwU2I5iMVC2CVQnzALiY=";  
      };

      propagatedBuildInputs = with pkgs.python3Packages; [
        absl-py
        easydict
        joblib
        matplotlib
        mnist
        nose
        pycodestyle
        pytorch
        scipy
        six
        torchvision
      ];

      doCheck = false;
    };

    mkDevShell = pkgs: pkgs.mkShell {
      buildInputs = [
        pkgs.python3
        pkgs.python3Packages.virtualenv
        # pkgs.python3Packages.tensorflow
        pkgs.python3Packages.pytorch
        (mkCleverHans pkgs)
      ];
    };

  in {
    packages.x86_64-linux.cleverhans = mkCleverHans nixpkgs.legacyPackages.x86_64-linux;
    packages.aarch64-darwin.cleverhans = mkCleverHans nixpkgs.legacyPackages.aarch64-darwin;
    packages.x86_64-darwin.cleverhans = mkCleverHans nixpkgs.legacyPackages.x86_64-darwin;

    devShells.x86_64-linux.default = mkDevShell nixpkgs.legacyPackages.x86_64-linux;
    devShells.aarch64-darwin.default = mkDevShell nixpkgs.legacyPackages.aarch64-darwin;
    devShells.x86_64-darwin.default = mkDevShell nixpkgs.legacyPackages.x86_64-darwin;

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.cleverhans;
    defaultPackage.aarch64-darwin = self.packages.aarch64-darwin.cleverhans;
    defaultPackage.x86_64-darwin = self.packages.x86_64-darwin.cleverhans;
  };
}