defmodule Litmus.MixProject do
  use Mix.Project

  @github_url "https://github.com/lob/litmus"

  def project do
    [
      app: :litmus,
      version: "1.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_deps: :apps_direct,
        plt_add_apps: [:plug],
        ignore_warnings: ".dialyzer_ignore"
      ],

      # Docs
      name: "litmus",
      description: "Data validation in elixir",
      source_url: @github_url,
      homepage_url: @github_url,
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      package: [
        files: ~w(mix.exs lib LICENSE* README.md CHANGELOG.md),
        maintainers: ["Lob"],
        licenses: ["MIT"],
        links: %{
          "GitHub" => @github_url
        }
      ],

      # ExCoveralls
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
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
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.11", only: :test},
      {:plug, ">= 1.8.0", optional: true},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
