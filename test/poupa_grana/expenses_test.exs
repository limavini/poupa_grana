defmodule PoupaGrana.ExpensesTest do
  use PoupaGrana.DataCase
  alias PoupaGrana.Expenses

  describe "list_expenses_by_user/2" do
    test "returns all expenses of an user" do
      insert(:expense)
      %{user_id: user_id} = insert(:expense)

      assert Expenses.list_expenses_by_user(user_id) |> length() == 1
    end

    test "returns all expenses of an user sorted by name" do
      %{user: user} = insert(:expense, %{name: "B"})
      insert(:expense, %{name: "A", user: user})

      expenses = Expenses.list_expenses_by_user(user.id, %{sort_by: :name, sort_order: :asc})
      assert Enum.map(expenses, & &1.name) == ["A", "B"]
    end

    test "returns all expenses paginated" do
      %{user: user} = insert(:expense)
      insert(:expense, %{user: user})

      [first_page_user] =
        expenses = Expenses.list_expenses_by_user(user.id, %{page_size: 1, page: 1})

      assert length(expenses) == 1

      [second_page_user] =
        expenses = Expenses.list_expenses_by_user(user.id, %{page_size: 1, page: 2})

      refute first_page_user.id == second_page_user.id

      assert length(expenses) == 1

      expenses = Expenses.list_expenses_by_user(user.id, %{page_size: 1, page: 3})

      assert length(expenses) == 0
    end
  end

  describe "get_expense!/1" do
    test "returns the expense" do
      expense = insert(:expense)

      assert Expenses.get_expense!(expense.id, [:category, :user]) ==
               expense
    end

    test "raises an error if the expense does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Expenses.get_expense!(123)
      end
    end
  end

  describe "create_expense/1" do
    test "creates a expense" do
      attrs = params_with_assocs(:expense)

      assert {:ok, expense} = Expenses.create_expense(attrs)
      Assertions.assert_maps_equal(attrs, expense, Map.keys(attrs))
    end

    test "returns an error changeset with invalid attributes" do
      attrs = params_for(:expense, %{name: nil})

      assert {:error, _changeset} = Expenses.create_expense(attrs)
      assert [] == Repo.all(Expenses.Expense)
    end
  end

  describe "update_expense/2" do
    test "updates the expense" do
      expense = insert(:expense)
      attrs = %{name: "new name"}

      assert {:ok, updated_expense} = Expenses.update_expense(expense, attrs)
      assert updated_expense.name == "new name"
    end
  end

  describe "delete_expense" do
    test "deletes the expense" do
      expense = insert(:expense)

      assert Expenses.delete_expense(expense)

      assert_raise Ecto.NoResultsError, fn ->
        Expenses.get_expense!(expense.id)
      end
    end
  end
end
