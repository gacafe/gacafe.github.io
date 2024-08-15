{
  inputs = {
    nixpkgs.url        = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url    = "github:numtide/flake-utils";
    nixpkgsRuby271.url = "github:nixos/nixpkgs/3913f6a514fa3eb29e34af744cc97d0b0f93c35c";
  };

  outputs = inputs: with inputs; flake-utils.lib.eachDefaultSystem (system:
  let pkgs = import nixpkgs { inherit system; };
      ruby271Pkgs = import nixpkgsRuby271 { inherit system; };
      ruby = ruby271Pkgs.ruby_2_7;
      gems = ruby271Pkgs.bundlerEnv {
        name = "jekyll-env";
        inherit ruby;
        gemdir = ./.;
      };
  in {
    devShell = pkgs.mkShell {
      packages = with pkgs; [
        gems
        gems.wrappedRuby
        bundix
      ];
    };
  });
}
