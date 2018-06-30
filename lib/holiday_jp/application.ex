defmodule HolidayJp.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      HolidayJp.Holidays
    ]

    opts = [strategy: :one_for_one, name: HolidayJp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
