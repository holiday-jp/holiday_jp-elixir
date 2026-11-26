defmodule Mix.Tasks.HolidayJp.Update do
  @moduledoc """
  Update dependencies and regenerate holiday data.
  """

  use Mix.Task

  @shortdoc "Update dependencies and holiday data"

  @impl true
  def run(_) do
    IO.puts("+ mix deps.update --all")
    Mix.Task.run("deps.update", ["--all"])
    IO.puts("+ mix hex.outdated")
    Mix.Task.run("hex.outdated")
    IO.puts("+ git submodule update --remote")
    {result, 0} = System.cmd("git", ["submodule", "update", "--remote"])
    IO.puts(result)
    IO.puts("+ mix generate.holidays")
    Mix.Task.run("generate.holidays")
  end
end
