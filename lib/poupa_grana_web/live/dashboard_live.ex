defmodule PoupaGranaWeb.DashboardLive do
  alias PoupaGrana.Expenses
  use PoupaGranaWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, show_category_modal: false)}
  end

  def render(assigns) do
    ~H"""
    Olá, <%= @current_user.email %>!
    <div>
      <button phx-click={show_modal("add-expense")} class="btn btn-primary">Nova despesa</button>
      <button phx-click={show_modal("add-category")} class="btn btn-primary">
        Nova categoria
      </button>

      <.live_component
        module={PoupaGranaWeb.AddExpense}
        id={:add_expense}
        current_user_id={@current_user.id}
      />
      <.live_component module={PoupaGranaWeb.AddCategory} id={:add_category} />
    </div>

    <div>
      <.live_component
        module={PoupaGranaWeb.ExpensesTable}
        id={:expenses_table}
        current_user_id={@current_user.id}
      />
    </div>
    """
  end

  def handle_info({:category_created, category}, socket) do
    socket = put_flash(socket, :info, "Category \"#{category.name}\" created successfully!")
    {:noreply, socket}
  end

  def handle_info({:expense_created, expense}, socket) do
    socket = put_flash(socket, :info, "Expense \"#{expense.name}\" created successfully!")
    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("show-category-modal", _, socket) do
    {:noreply, assign(socket, show_category_modal: true)}
  end
end
