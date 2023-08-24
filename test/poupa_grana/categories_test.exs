defmodule PoupaGrana.CategoriesTest do
  use PoupaGrana.DataCase
  alias PoupaGrana.Categories

  describe "list_categories" do
    test "returns all categories" do
      category = insert(:category)
      assert [category] == Categories.list_categories()
    end
  end

  describe "get_category!/1" do
    test "returns the category" do
      category = insert(:category)
      assert category == Categories.get_category!(category.id)
    end

    test "raises an error if the category does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_category!(123)
      end
    end
  end

  describe "create_category/1" do
    test "creates a category" do
      attrs = params_for(:category)

      assert {:ok, category} = Categories.create_category(attrs)
      Assertions.assert_maps_equal(category, attrs, Map.keys(attrs))
    end

    test "returns an error changeset with invalid attributes" do
      attrs = params_for(:category, %{name: nil})

      assert {:error, changeset} = Categories.create_category(attrs)
      assert [] == Repo.all(Categories.Category)
    end
  end

  describe "update_category/2" do
    test "updates the category" do
      category = insert(:category)
      attrs = %{name: "new name"}

      assert {:ok, updated_category} = Categories.update_category(category, attrs)
      assert updated_category.name == "new name"
    end

    test "returns an error changeset with invalid attributes" do
      category = insert(:category)
      attrs = %{name: nil}

      assert {:error, changeset} = Categories.update_category(category, attrs)
    end
  end

  describe "delete_categry/1" do
    test "deletes the category" do
      category = insert(:category)
      assert {:ok, category} = Categories.delete_category(category)

      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_category!(category.id)
      end
    end
  end

  describe "change_category/2" do
    test "changes the category" do
      category = insert(:category)
      attrs = %{name: "new name"}

      assert %Ecto.Changeset{changes: %{name: "new name"}} =
               Categories.change_category(category, attrs)
    end

    test "returns an error changeset with invalid attributes" do
      category = insert(:category)
      attrs = %{name: nil}

      assert %Ecto.Changeset{valid?: false} = Categories.change_category(category, attrs)
    end
  end
end
