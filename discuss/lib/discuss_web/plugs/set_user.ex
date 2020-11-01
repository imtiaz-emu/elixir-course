defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.User
  alias Discuss.Repo

  def init(default), do: default

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = user_id && Repo.get(User, user_id)

    cond do
      user ->
        assign(conn, :user, user)

      true ->
        assign(conn, :user, nil)
    end
  end
end
