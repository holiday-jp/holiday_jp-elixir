defmodule HolidayJp.Holiday do
  @moduledoc """
  Holiday.

      iex> %HolidayJp.Holiday{date: ~D[2017-11-23], week: "木", week_en: "Thursday", name: "勤労感謝の日", name_en: "Labor Thanksgiving Day"}
      %HolidayJp.Holiday{date: ~D[2017-11-23], week: "木", week_en: "Thursday", name: "勤労感謝の日", name_en: "Labor Thanksgiving Day"}
  """

  @type t :: %__MODULE__{
          date: Date.t(),
          week: String.t(),
          week_en: String.t(),
          name: String.t(),
          name_en: String.t()
        }

  @enforce_keys [:date, :week, :week_en, :name, :name_en]
  defstruct [:date, :week, :week_en, :name, :name_en]
end
