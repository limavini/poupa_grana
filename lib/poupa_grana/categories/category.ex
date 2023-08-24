defmodule PoupaGrana.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :color, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :color])
    |> validate_required([:name, :color])
  end
end
