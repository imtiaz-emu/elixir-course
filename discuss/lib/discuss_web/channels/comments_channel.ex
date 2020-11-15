defmodule DiscussWeb.CommetnsChannel do
  use Phoenix.Channel

  def join(name, _params, socket) do
    {:ok, %{msg: "hello"}, socket}
  end

  def handle_in() do

  end

end