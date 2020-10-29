defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller

  plug(Ueberauth)

  alias Discuss.User
  alias Discuss.Repo

  def callback(conn, params) do
    %{assigns: %{ueberauth_auth: auth}} = conn
    %{"provider" => provider} = params

    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: provider
    }

    changeset = User.changeset(%User{}, user_params)
    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, 'Welcome Back!')
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, 'Error signing in!')
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end
end
