defmodule PoupaGrana.Repo do
  use Ecto.Repo,
    otp_app: :poupa_grana,
    adapter: Ecto.Adapters.Postgres
end
