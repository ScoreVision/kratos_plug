defmodule KratosPlug.MixProject do
  use Mix.Project

  def project do
    [
      app: :kratos_plug,
      version: "0.1.0",
      elixir: "~> 1.10",
      description: "Provides authentication to Plug applications by integrating with Ory Kratos.",
      source_url: "https://github.com/ScoreVision/kratos_plug",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        extras: [
          "README.md",
          "CHANGELOG.md",
          "GLOSSARY.md",
          "LICENSE.md"
        ],
        groups_for_modules: [
          Plugs: [
            KratosPlug.Plugs.EnsureAuthenticated,
            KratosPlug.Plugs.KratosNativePipeline,
            KratosPlug.Plugs.KratosSession
          ],
          "Data types": [KratosPlug.Identifiers, KratosPlug.Config],
          Behaviours: [KratosPlug.KratosClient],
          "Client adapters": [KratosPlug.KratosClient.TeslaAdapter],
          Testing: [KratosPlug.IdentifiersMock, KratosPlug.KratosClient.TeslaAdapterMock]
        ]
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
      # Plug functions
      {:plug, "~> 1.0"},
      # JSON functions
      {:jason, "~> 1.0"},
      # HTTP Client
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.13"},
      # docs
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/ScoreVision/kratos_plug",
        "Ory Kratos": "https://github.com/ory/kratos",
        Ory: "https://www.ory.sh/",
        ScoreVision: "https://www.scorevision.com/"
      },
      maintainers: ["Zach Norris"],
      files: ~w(lib .formatter.exs mix.exs README.md CHANGELOG.md)
    }
  end
end
