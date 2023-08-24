defmodule PoupaGranaWeb.HomeLive do
  use PoupaGranaWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <div class="row">
        <div class="col-12">
          <h1 class="text-3xl text-center">Bem vindo ao Poupa Grana! H1</h1>
          <h4 class="text-center">O seu app de finanças</h4>
        </div>
        <.link href={~p"/dashboard"}>Dashboard</.link>
      </div>
    </div>
    """
  end
end
