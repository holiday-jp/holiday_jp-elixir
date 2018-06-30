defmodule HolidayJp.Holidays do
  @moduledoc false

  alias HolidayJp.Holiday

  use GenServer

  def start_link(arg), do: GenServer.start_link(__MODULE__, arg, name: __MODULE__)

  @spec holidays :: [Holiday.t()]
  def holidays, do: GenServer.call(__MODULE__, :holidays)

  @spec between(Date.t(), Date.t()) :: [Holiday.t()]
  def between(start, last), do: GenServer.call(__MODULE__, {:between, start, last})

  @spec holiday?(Date.t()) :: boolean
  def holiday?(date), do: GenServer.call(__MODULE__, {:holiday?, date})

  @impl true
  def init(_) do
    {:ok, tab} =
      [:code.priv_dir(:holiday_jp), "holidays.ets"]
      |> Path.join()
      |> String.to_charlist()
      |> :ets.file2tab()

    [holidays: holidays] = :ets.lookup(tab, :holidays)
    true = :ets.delete(tab)
    {:ok, holidays}
  end

  @impl true
  def handle_call(:holidays, _from, holidays), do: {:reply, holidays, holidays}

  def handle_call({:between, start, last}, _from, holidays) do
    between_holidays =
      for %{date: date} = holiday <- holidays,
          (case {Date.compare(start, date), Date.compare(date, last)} do
             {:lt, :lt} -> true
             {:eq, :lt} -> true
             {:lt, :eq} -> true
             {:eq, :eq} -> true
             _ -> false
           end),
          do: holiday

    {:reply, between_holidays, holidays}
  end

  def handle_call({:holiday?, date}, _from, holidays),
    do: {:reply, Enum.any?(holidays, &(&1.date == date)), holidays}
end
