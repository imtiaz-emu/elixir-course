defmodule DiscussWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias DiscussWeb.Router.Helpers

  def init(default), do: default

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:info, "You're not authorized")
      |> redirect(to: Helpers.topic_path(conn, :index))
      |> halt()
    end

  end

end