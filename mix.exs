defmodule HolidayJp.Mixfile do
  use Mix.Project

  def project do
    [
      app: :holiday_jp,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      dialyzer: [
        ignore_warnings: "dialyzer.ignore-warnings"
      ],
      elixir: "~> 1.5",
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.2.3",

      # Docs
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      homepage_url: "https://hexdocs.pm/holiday_jp",
      source_url: "https://github.com/holiday-jp/holiday_jp-elixir",
      name: "HolidayJp"
    ]
  end

  def application do
    [
      extra_applications: [],
      mod: {HolidayJp.Application, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.18", only: :dev},
      {:inner_cotton, github: "ne-sachirou/inner_cotton", only: [:dev, :test]},
      {:relax_yaml, "~> 0.1", only: [:dev, :test]}
    ]
  end

  defp description do
    """
    Japanese holiday.
    """
  end

  defp package do
    [
      licenses: ["GPL-3.0"],
      name: :holiday_jp,
      maintainers: ["ne_Sachirou <utakata.c4se@gmail.com>"],
      links: %{
        GitHub: "https://github.com/holiday-jp/holiday_jp-elixir"
      },
      files: ["LICENSE", "README.md", "mix.exs", "priv", "lib/holiday_jp.ex", "lib/holiday_jp"]
    ]
  end
end
