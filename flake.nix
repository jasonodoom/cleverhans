{
  description = "A flake for building and developing on the CleverHans library.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05"; 
  };

  outputs = { self, nixpkgs }: let

   mkCleverHans = pkgs: pkgs.python310Packages.buildPythonPackage rec {
      pname = "cleverhans";
      version = "master"; 
  
      src = pkgs.fetchFromGitHub {
        owner = "jasonodoom";
        repo = "cleverhans";
        rev = "master";  
        sha256 = "sha256-ox7psBA0qqc9/J3HRNjzj1jXwU2I5iMVC2CVQnzALiY=";  
      };

      propagatedBuildInputs = with pkgs.python310Packages; [
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
        tensorflow
        tensorflow-probability
        dm-tree
        torchvision
      ];

      doCheck = false;
    };

    mkDevShell = pkgs: pkgs.mkShell {
      buildInputs = [
        pkgs.python310
        pkgs.python310Packages.virtualenv
        pkgs.python310Packages.pytorch
        pkgs.python310Packages.tensorflow
        pkgs.python310Packages.tensorflow-probability
        pkgs.python310Packages.dm-tree

        (mkCleverHans pkgs)
      ];
    };

  in {
    packages.x86_64-linux.cleverhans = mkCleverHans nixpkgs.legacyPackages.x86_64-linux;

    devShells.x86_64-linux.default = mkDevShell nixpkgs.legacyPackages.x86_64-linux;

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.cleverhans;
  };
}