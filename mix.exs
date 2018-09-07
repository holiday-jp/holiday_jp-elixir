defmodule HolidayJp.Mixfile do
  use Mix.Project

  def project do
    [
      app: :holiday_jp,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      dialyzer: [
        flags: [:no_undefined_callbacks],
        ignore_warnings: "dialyzer.ignore-warnings",
        plt_add_apps: [:mix],
        remove_defaults: [:unknown]
      ],
      elixir: "~> 1.6",
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.2.4",

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
      links: %{
        GitHub: "https://github.com/holiday-jp/holiday_jp-elixir"
      },
      maintainers: ["ne_Sachirou <utakata.c4se@gmail.com>"],
      name: :holiday_jp
    ]
  end
end
