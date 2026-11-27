defmodule HolidayJp.Holidays do
  @moduledoc false

  alias HolidayJp.Holiday

  data_path = Path.expand("../../priv/holidays.exs", __DIR__)
  @external_resource data_path
  {rows, _} = Code.eval_file(data_path)

  unless is_list(rows), do: raise("#{data_path}: expected a list of holiday rows")

  holidays =
    rows
    |> Enum.with_index(1)
    |> Enum.map(fn {row, index} ->
      {date, week, week_en, name, name_en} =
        case row do
          {date, week, week_en, name, name_en} -> {date, week, week_en, name, name_en}
          _ -> raise "#{data_path}: row #{index}: expected five fields"
        end

      for {field, value} <- [date: date, week: week, week_en: week_en, name: name, name_en: name_en] do
        unless is_binary(value) and String.valid?(value) and String.trim(value) != "" do
          raise "#{data_path}: row #{index}: #{field} must be a nonempty string"
        end
      end

      parsed_date =
        case Date.from_iso8601(date) do
          {:ok, parsed} -> parsed
          {:error, _} -> raise "#{data_path}: row #{index}: invalid date #{inspect(date)}"
        end

      %Holiday{
        date: parsed_date,
        week: week,
        week_en: week_en,
        name: name,
        name_en: name_en
      }
    end)

  if holidays == [], do: raise("holiday data is empty")

  unless holidays
         |> Enum.chunk_every(2, 1, :discard)
         |> Enum.all?(fn [first, last] -> Date.compare(first.date, last.date) == :lt end) do
    raise "holiday dates must be strictly increasing"
  end

  @ordered List.to_tuple(holidays)

  @spec between(Date.t(), Date.t()) :: [Holiday.t()]
  def between(%Date{} = start, %Date{} = last) do
    if Date.compare(start, last) == :gt do
      []
    else
      first = lower_bound(start, 0, tuple_size(@ordered))
      after_last = upper_bound(last, first, tuple_size(@ordered))
      for index <- first..(after_last - 1)//1, do: elem(@ordered, index)
    end
  end

  @spec holiday?(Date.t()) :: boolean()
  def holiday?(%Date{} = date) do
    index = lower_bound(date, 0, tuple_size(@ordered))
    index < tuple_size(@ordered) and Date.compare(elem(@ordered, index).date, date) == :eq
  end

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
