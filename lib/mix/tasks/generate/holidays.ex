defmodule Mix.Tasks.Generate.Holidays do
  @moduledoc """
  Generate the holidays DB
  """

  alias HolidayJp.Holiday

  use Mix.Task

  @shortdoc "Generate the holidays DB"

  @impl true
  def run(_) do
    :ok = Application.start(:yamerl)
    src = Path.join([__DIR__, "..", "..", "..", "..", "holiday_jp", "holidays_detailed.yml"])
    dest = Path.join(:code.priv_dir(:holiday_jp), "holidays.ets")

    holidays =
      src
      |> :yamerl.decode_file()
      |> hd
      |> Enum.map(fn {date, holiday} ->
        holiday = Map.new(holiday)

        %Holiday{
          date: Date.from_iso8601!(to_string(date)),
          week: to_string(holiday['week']),
          week_en: to_string(holiday['week_en']),
          name: to_string(holiday['name']),
          name_en: to_string(holiday['name_en'])
        }
      end)
      |> Enum.sort(&(Date.compare(&1.date, &2.date) == :lt))

    table = :ets.new(:holiday_jp, [:set, :named_table])
    true = :ets.insert_new(table, {:holidays, holidays})
    :ok = :ets.tab2file(table, :erlang.binary_to_list(dest))
    true = :ets.delete(table)
  end
end
