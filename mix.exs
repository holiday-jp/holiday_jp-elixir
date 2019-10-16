defmodule HolidayJp.Mixfile do
  use Mix.Project

  @github "https://github.com/holiday-jp/holiday_jp-elixir"

  def project do
    [
      app: :holiday_jp,
      build_embedded: Mix.env() == :prod,
      deps: deps(Mix.env()),
      description: description(),
      dialyzer: [
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
        "coveralls.travis": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.3.5",

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

  defp deps(:publish), do: [{:ex_doc, "~> 0.18", only: :dev, runtime: false}]

  defp deps(_) do
    [
      # {:inner_cotton, "~> 0.3", only: [:dev, :test]},
      {:inner_cotton, github: "ne-sachirou/inner_cotton", only: [:dev, :test]},
      {:yamerl, "~> 0.7", only: :dev}
      | deps(:publish)
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
      maintainers: ["ne_Sachirou <utakata.c4se@gmail.com>"],
      name: :holiday_jp
    ]
  end
end
