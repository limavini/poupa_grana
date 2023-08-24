defmodule PoupaGrana.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :name, :string
      add :value, :integer
      add :date, :date
      add :category_id, references(:categories)
      add :user_id, references(:users)

      timestamps()
    end
  end
end
