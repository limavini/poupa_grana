defmodule PoupaGranaWeb.ExpensesTable do
  use PoupaGranaWeb, :live_component
  alias PoupaGrana.Expenses

  def mount(socket) do
    # TODO: temp assign
    {:ok, socket}
  end

  def update(assigns, socket) do
    expenses = Expenses.list_expenses_by_user(assigns.current_user_id)

    {:ok, assign(socket, expenses: expenses)}
  end

  def render(assigns) do
    ~H"""
    <table class="table">
      <thead>
        <tr>
          <th>Nome</th>
          <th>Valor</th>
        </tr>
      </thead>
      <tbody>
        <tr :for={expense <- @expenses}>
          <td><%= expense.name %></td>
          <td><%= Money.to_string(expense.value) %></td>
        </tr>
      </tbody>
    </table>
    """
  end
end
