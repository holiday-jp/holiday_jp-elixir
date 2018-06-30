defmodule Mix.Tasks.Update do
  @moduledoc """
  Update all dependencies.
  """

  use Mix.Task

  @shortdoc "Update all dependencies."

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
