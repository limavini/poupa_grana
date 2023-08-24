defmodule PoupaGrana.Expenses do
  @moduledoc """
  The Expenses context.
  """

  import Ecto.Query, warn: false
  alias PoupaGrana.Repo
  alias PoupaGrana.Expenses.Expense
  alias PoupaGrana.Helpers

  @doc """
  Returns the list of expenses by user.

  ## Examples

      iex> list_expenses_by_user(1, %{ page_size: 10, page: 1, sort_by: :name, sort_order: :asc } }})
      [%Expense{}, ...]
  """
  def list_expenses_by_user(user_id, params \\ %{}) do
    from(
      e in Expense,
      where: e.user_id == ^user_id
    )
    |> sort(params)
    |> paginate(params)
    |> Repo.all()
  end

  defp sort(query, %{sort_by: sort_by, sort_order: sort_order}) do
    query
    |> order_by({^sort_order, ^sort_by})
  end

  defp sort(query, _), do: query

  defp paginate(query, %{page_size: page_size, page: page}) do
    query
    |> limit(^page_size)
    |> offset(^page_size * (^page - 1))
  end

  defp paginate(query, _), do: query

  @doc """
  Gets a single expense.

  Raises `Ecto.NoResultsError` if the Expense does not exist.

  ## Examples

      iex> get_expense!(123)
      %Expense{}

      iex> get_expense!(456)
      ** (Ecto.NoResultsError)

  """
  def get_expense!(id, preloads \\ []) do
    Repo.get!(Expense, id)
    |> Repo.preload(preloads)
  end

  @doc """
  Creates a expense.

  ## Examples

      iex> create_expense(%{field: value})
      {:ok, %Expense{}}

      iex> create_expense(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_expense(attrs \\ %{}) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end

  defp bulk_insert_expenses(expenses) do
    expenses =
      expenses
      |> Enum.map(fn expense ->
        %{
          inserted_at: Helpers.naive_date_time_now(),
          updated_at: Helpers.naive_date_time_now()
        }
        |> Map.merge(expense)
      end)

    Expense
    |> Repo.insert_all(expenses)
  end

  def process_invoice(invoice) do
    invoice
    # TODO: Handle other banks
    |> PoupaGrana.Parsers.Bradesco.parse()
    |> bulk_insert_expenses()
  end

  @doc """
  Updates a expense.

  ## Examples

      iex> update_expense(expense, %{field: new_value})
      {:ok, %Expense{}}

      iex> update_expense(expense, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a expense.

  ## Examples

      iex> delete_expense(expense)
      {:ok, %Expense{}}

      iex> delete_expense(expense)
      {:error, %Ecto.Changeset{}}

  """
  def delete_expense(%Expense{} = expense) do
    Repo.delete(expense)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking expense changes.

  ## Examples

      iex> change_expense(expense)
      %Ecto.Changeset{data: %Expense{}}

  """
  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    Expense.changeset(expense, attrs)
  end
end
