defmodule HolidayJp.Holiday do
  @moduledoc """
  Holiday.

      iex> %HolidayJp.Holiday{date: ~D[2017-11-23], week: "木", week_en: "Thursday", name: "勤労感謝の日", name_en: "Labor Thanksgiving Day"}
      %HolidayJp.Holiday{date: ~D[2017-11-23], week: "木", week_en: "Thursday", name: "勤労感謝の日", name_en: "Labor Thanksgiving Day"}
  """

  @type t :: %__MODULE__{
          date: Date.t(),
          week: binary,
          week_en: binary,
          name: binary,
          name_en: binary
        }

  defstruct date: ~D[1970-01-01], week: "", week_en: "", name: "", name_en: ""
end
