Ecto.Adapters.SQL.Sandbox.mode(PT.Test.Repo, {:shared, self()})

defmodule PTTest do
  use ExUnit.Case, async: true
  alias Ecto.Adapters.SQL.Sandbox
  alias PT.Test.Repo
  alias PT.Test.Support.Post

  @example_name "Hi"

  describe "given a record exists" do
    setup _ do
      :ok = Sandbox.checkout(Repo)

      %{id: id} = %Post{name: @example_name} |> Repo.insert!

      [existing_item_id: id]
    end

    test "fetch_by/2 returns an :ok tagged tuple", %{existing_item_id: id} do
      {:ok, result} = Repo.fetch_by(Post, name: @example_name)
      assert id == result.id
    end

    test "fetch_by/2 returns a :not_found tagged tuple if not found" do
      {:not_found, result} = Repo.fetch_by(Post, name: @example_name <> "a")

      assert result == Post
    end
  end
end
