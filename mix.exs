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
      elixir: "~> 1.13",
      package: package(),
      start_permanent: Mix.env() == :prod,
      version: "0.3.7",

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
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:yamerl, "~> 0.7", only: [:dev, :test]}
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
