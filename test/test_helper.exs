{:ok, _} = Application.ensure_all_started(:poupa_grana)
ExUnit.start()
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(PoupaGrana.Repo, :manual)
