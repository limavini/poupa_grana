defmodule PoupaGrana.Helpers do
  def naive_date_time_now, do: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
end
