defmodule Netcode.Mixfile do
  use Mix.Project

  def project do
    [
      app: :netcode,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),

      #Docs
      name: "Netcode",
      source_url: "https://github.com/elixir-lang/ex_doc",
      homepage_url: "https://github.com/elixir-lang/ex_doc",
      docs: [main: "Netcode", # The main page in the docs
#             logo: "path/to/logo.png",
             extras: ["README.md", "markdown/STANDARD.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Netcode, []},
      extra_applications: [:logger, :gen_state_machine]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchfella, "~> 0.3.0", only: :dev},
      {:libsodium, "~> 0.0.10"},
      {:gen_state_machine, "~> 2.0"},
      { :tonic, "~> 0.0.2" },
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
