defmodule Litmus.MixProject do
  use Mix.Project

  @github_url "https://github.com/lob/litmus"

  def project do
    [
      app: :litmus,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_deps: :apps_direct],

      # Docs
      name: "litmus",
      description: "Data schema validation in elixir",
      source_url: @github_url,
      homepage_url: @github_url,
      files: ~w(mix.exs lib LICENSE.md README.md CHANGELOG.md),
      docs: [
        main: "Litmus",
        extras: ["README.md"]
      ],
      package: [
        maintainers: ["Lob"],
        licenses: ["MIT"],
        links: %{
          "GitHub" => @github_url,
        }
      ],

      #ExCoveralls
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.travis": :test,
        "coveralls.html": :test
      ]
    ]
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
      {:ex_doc, "~> 0.18.0", only: :dev, runtime: false},
      {:credo, "~> 0.9.1", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.8", only: :test},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false}
    ]
  end
end
