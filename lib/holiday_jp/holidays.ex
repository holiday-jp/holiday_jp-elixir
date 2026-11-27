defmodule HolidayJp.Holidays do
  @moduledoc false

  alias HolidayJp.Holiday

  data_path = Path.expand("../../priv/holidays.exs", __DIR__)
  @external_resource data_path
  {rows, _} = Code.eval_file(data_path)

  @holidays Enum.map(rows, fn {date, week, week_en, name, name_en} ->
              %Holiday{
                date: Date.from_iso8601!(date),
                week: week,
                week_en: week_en,
                name: name,
                name_en: name_en
              }
            end)
  @ordered List.to_tuple(@holidays)
  @dates MapSet.new(@holidays, & &1.date)

  @spec holidays :: [Holiday.t()]
  def holidays, do: @holidays

  @spec between(Date.t(), Date.t()) :: [Holiday.t()]
  def between(start, last) do
    if Date.compare(start, last) == :gt do
      []
    else
      first = lower_bound(start, 0, tuple_size(@ordered))
      after_last = upper_bound(last, first, tuple_size(@ordered))
      for index <- first..(after_last - 1)//1, do: elem(@ordered, index)
    end
  end

  @spec holiday?(Date.t()) :: boolean()
  def holiday?(date), do: MapSet.member?(@dates, date)

  defp lower_bound(_date, low, high) when low == high, do: low

  defp lower_bound(date, low, high) do
    mid = div(low + high, 2)

    if Date.compare(elem(@ordered, mid).date, date) == :lt do
      lower_bound(date, mid + 1, high)
    else
      lower_bound(date, low, mid)
    end
  end

  defp upper_bound(_date, low, high) when low == high, do: low

  defp upper_bound(date, low, high) do
    mid = div(low + high, 2)

    if Date.compare(elem(@ordered, mid).date, date) == :gt do
      upper_bound(date, low, mid)
    else
      upper_bound(date, mid + 1, high)
    end
  end
end
