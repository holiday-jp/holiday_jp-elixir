defmodule HolidayJp.MixProject do
  use Mix.Project

  @github "https://github.com/holiday-jp/holiday_jp-elixir"

  def project do
    [
      app: :holiday_jp,
      deps: deps(),
      description: description(),
      dialyzer: [
        plt_add_apps: [:mix],
        remove_defaults: [:unknown]
      ],
      elixir: "~> 1.19",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [summary: [threshold: 0]],
      version: "0.4.0",

      # Docs
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      homepage_url: @github,
      name: "HolidayJp",
      source_url: @github
    ]
  end

  def application do
    [
      extra_applications: [],
      mod: {HolidayJp.Application, []}
    ]
  end

  defp elixirc_paths(env) when env in [:dev, :test], do: ["lib", "dev"]
  defp elixirc_paths(_env), do: ["lib"]

  defp deps do
    [
      {:credo, "~> 1.7", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false},
      {:stream_data, "~> 1.0", only: :test},
      {:yamerl, "~> 0.7", only: [:dev, :test]}
    ]
  end

  defp description do
    """
    Japanese holiday.
    """
  end

  defp package do
    [
      files: ["LICENSE", "README.md", "mix.exs", "priv", "lib/holiday_jp.ex", "lib/holiday_jp"],
      licenses: ["GPL-3.0-or-later"],
      links: %{GitHub: @github},
      maintainers: ["ne_Sachirou <utakata.c4se@gmail.com>"]
    ]
  end
end
