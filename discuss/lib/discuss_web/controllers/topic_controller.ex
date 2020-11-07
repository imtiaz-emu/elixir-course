defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  
  alias Discuss.Topic
  alias Discuss.User
  alias Discuss.Repo

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :edit, :create, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do 
    topics = Repo.all(Topic)

    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    
    render conn, "new.html", topic: changeset 
  end

  def create(conn, params) do
    %{"topic" => topic} = params

    changeset = Repo.get(User, conn.assigns.user.id)
                |> Ecto.build_assoc(:topics)
                |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} -> 
        conn
        |> put_flash(:info, "Successfully created new Topic!")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", topic: changeset 
    end
  end

  def edit(conn, %{"id" => id}) do
    topic = Repo.get(Topic, id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", topic: topic, changeset: changeset
  end

  def update(conn, %{"id" => id, "topic" => topic}) do
    old_topic = Repo.get(Topic, id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, topic} -> 
        conn
        |> put_flash(:info, "Successfully updated Topic!")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic 
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Topic, id) |> Repo.delete()

    conn
      |> put_flash(:info, "Successfully deleted Topic!")
      |> redirect(to: Routes.topic_path(conn, :index))
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:info, "You're not authorized")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end