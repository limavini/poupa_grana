defmodule PoupaGranaWeb.AddExpense do
  alias PoupaGrana.Categories
  alias PoupaGrana.Expenses
  alias PoupaGrana.Expenses.Expense

  use Phoenix.LiveComponent
  use PoupaGranaWeb, :live_view

  def mount(socket) do
    changeset = Expenses.change_expense(%Expense{})

    categories = Categories.list_categories()

    {:ok, assign(socket, form: to_form(changeset), categories: categories)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.modal
        id="add-expense"
        on_cancel={JS.navigate(~p"/dashboard")}
        on_confirm={hide_modal("add-expense")}
      >
        <h1 class="text-center text-2xl mb-6">Nova despesa</h1>
        <.form for={@form} phx-change="validate" phx-submit="save" phx-target={@myself}>
          <.input
            class="input w-full"
            container_class="mb-3"
            name="name"
            placeholder="Nome"
            field={@form[:name]}
            type="text"
          />
          <.input
            class="input w-full"
            container_class="mb-3"
            name="value"
            placeholder="Valor (R$)"
            field={@form[:value]}
            type="text"
          />
          <.input
            class="input w-full"
            container_class="mb-3"
            name="date"
            placeholder="Data"
            field={@form[:date]}
            type="date"
          />
          <.input name="user_id" field={@form[:user_id]} type="hidden" value={@current_user_id} />
          <.input
            type="select"
            field={@form[:category_id]}
            class="w-full"
            prompt="Selecione uma categoria"
            placeholder="Categoria"
            name="category_id"
            container_class="mb-3"
            options={Enum.map(@categories, fn cat -> {cat.name, cat.id} end)}
          />
          <div class="flex mt-3 ">
            <.button class="btn btn-success w-full" phx-disable-with="Saving...">Save</.button>
          </div>
        </.form>
      </.modal>
    </div>
    """
  end

  def handle_event("save", params, socket) do
    case Expenses.create_expense(params) do
      {:ok, category} ->
        IO.inspect(category)

        socket =
          push_event(socket, "js-exec", %{
            to: "#add-expense",
            attr: "data-confirmed"
          })

        send(self(), {:expense_created, category})

        {:noreply, socket}

      {:error, changeset} ->
        IO.inspect("error component")
        IO.inspect(changeset)
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("validate", params, socket) do
    # params = Map.put(params, "user_id", socket.assigns.current_user_id)

    changeset =
      %Expense{}
      |> Expenses.change_expense(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end
end
