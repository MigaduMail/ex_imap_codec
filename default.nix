with (import <nixpkgs> { });

stdenv.mkDerivation {
  name = "elixir-env";
  buildInputs = with pkgs; [
    elixir
    erlang
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy
  ];

  nativeBuildInputs = [ pkgs.postgresql_16 ];

  env.LANG = "en_US.UTF-8";
  env.ERL_AFLAGS = "-kernel shell_history enabled";

  RUST_BACKTRACE = 1;

  # Set the MIX_ENV environment variable, typically to "dev" for development
  # environment
  shellHook = ''
    export MIX_ENV=dev
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
  '';
}
