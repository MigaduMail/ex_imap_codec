with (import <nixpkgs> { });

stdenv.mkDerivation {
  name = "elixir-env";
  buildInputs = with pkgs; [
    elixir
    erlang
    chromedriver
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy
    # pkgs.postgresql
    # Add other dependencies, such as Node.js for Phoenix projects with Webpack
    # pkgs.nodejs
  ];

  nativeBuildInputs = [ pkgs.postgresql_16 ];

  env.LANG = "en_US.UTF-8";
  env.ERL_AFLAGS = "-kernel shell_history enabled";

  RUST_BACKTRACE = 1;

  postgresConf = writeText "postgresql.conf" ''
    # Add Custom Settings
    log_min_messages = warning
    log_min_error_statement = error
    log_min_duration_statement = 100  # ms
    log_connections = on
    log_disconnections = on
    log_duration = on
    #log_line_prefix = '[] '
    log_timezone = 'UTC'
    log_statement = 'all'
    log_directory = 'pg_log'
    log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
    logging_collector = on
    log_min_error_statement = error
  '';

  # ENV Variables
  #LD_LIBRARY_PATH = "${geos}/lib:${gdal}/lib";
  PGDATA = "${toString ./.}/.pg";

  PGHOST = "localhost";
  PGPORT = "5432";
  PGUSER = "postgres";
  PGDATABASE = "postgres";
  SOCKET_DIRECTORIES = "${toString ./.}/.db/postgres-sockets";

  # Set the MIX_ENV environment variable, typically to "dev" for development
  # environment
  shellHook = ''
    echo "Using ${pkgs.postgresql_16.name}."

    export MIX_ENV=dev
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH

    # echo "Using ${postgresql.name}."

    # # Setup: other env variables
    export PGHOST="$PGDATA"
    # Setup: DB
    [ ! -d $PGDATA ] && pg_ctl initdb -o "-U postgres" && cat "$postgresConf" >> $PGDATA/postgresql.conf
    # pg_ctl -o "-p 5432 -k $PGDATA" start ## makes the terminal unusable
    alias fin="pg_ctl stop && exit"
    alias pg="psql -p 5432 -U postgres"
  '';
}
