defmodule ExImapCodec.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_imap_codec,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Michael J. Bruderer"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/MigaduMail/ex_imap_codec"}
    ]
  end

  defp description do
    """
    A small wrapper over the rust imap library: https://github.com/duesee/imap-codec
    """
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.36.0", runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
