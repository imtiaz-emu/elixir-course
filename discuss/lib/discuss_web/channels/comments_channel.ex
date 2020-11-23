defmodule DiscussWeb.CommetnsChannel do
  use Phoenix.Channel

  alias Discuss.{Topic, Comment, Repo}

  def join(channel_name, _params, socket) do
    "comments:" <> topic_id = channel_name

    topic_id = String.to_integer(topic_id)
    topic = Topic
      |> Repo.get(topic_id)
      |> Repo.preload(:comments)

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(channel_name, %{"message" => content}, socket) do
    topic = socket.assigns.topic

    changeset = topic
      |> Ecto.build_assoc(:comments)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, _comment} ->
        {:reply, %{}, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

end