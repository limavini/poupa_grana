defmodule PoupaGrana.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :name, :string
    field :value, Money.Ecto.Amount.Type
    field :date, :date

    belongs_to :category, PoupaGrana.Categories.Category
    belongs_to :user, PoupaGrana.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:name, :value, :date, :category_id, :user_id])
    |> validate_required([:name, :value, :date, :category_id, :user_id])
  end
end
