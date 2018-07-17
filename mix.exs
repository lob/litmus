defmodule Litmus.MixProject do
  use Mix.Project

  @github_url "https://github.com/shraddha1704/litmus"

  def project do
    [
      app: :litmus,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "litmus",
      description: "Data schema validation in elixir",
      source_url: @github_url,
      homepage_url: @github_url,
      files: ~w(mix.exs lib LICENSE.md README.md CHANGELOG.md),
      docs: [
        main: "litmus",
        extras: ["README.md"]
      ],
      package: [
        maintainers: ["Lob"],
        licenses: ["MIT"],
        links: %{
          "GitHub" => @github_url,
        }
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
      {:ex_doc, "~> 0.18.0", only: :dev, runtime: false}
    ]
  end
end
