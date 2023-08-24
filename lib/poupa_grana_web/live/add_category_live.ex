defmodule PoupaGranaWeb.AddCategory do
  alias PoupaGrana.Categories
  alias PoupaGrana.Categories.Category

  use PoupaGranaWeb, :live_component

  def mount(socket) do
    changeset = Categories.change_category(%Category{})

    {:ok, assign(socket, form: to_form(changeset))}
  end

  def update(assigns, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.modal
        id="add-category"
        on_cancel={JS.navigate(~p"/dashboard")}
        on_confirm={hide_modal("add-category")}
      >
        <.form for={@form} phx-change="validate" phx-submit="save" phx-target={@myself}>
          <h1 class="text-center text-2xl mb-6">Nova categoria</h1>
          <div class="join grid grid-cols-4">
            <.input
              name="name"
              placeholder="Nome"
              field={@form[:name]}
              class="input w-full mb-3 rounded-r-none"
              container_class="join-item col-span-3"
              phx-debounce={300}
            />
            <.input
              name="color"
              placeholder="Cor"
              type="color"
              field={@form[:color]}
              phx-debounce={300}
              class="h-12 border-r-2 !border-transparent !border-none w-full"
              container_class="join-item "
            />
          </div>
          <.button class="btn btn-success w-full" phx-disable-with="Saving...">Save</.button>
        </.form>
      </.modal>
    </div>
    """
  end

  def handle_event("validate", params, socket) do
    changeset =
      %Category{}
      |> Categories.change_category(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", params, socket) do
    case Categories.create_category(params) do
      {:ok, category} ->
        socket =
          push_event(socket, "js-exec", %{
            to: "#add-category",
            attr: "data-confirmed"
          })

        send(self(), {:category_created, category})

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
