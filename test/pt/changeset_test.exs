defmodule PT.ChangesetTest do
  use ExUnit.Case, async: true

  alias PT.Changeset
  alias PT.Test.Support.Post
  alias PT.Test.Support.PostFactory

  describe "given two changesets" do
    setup _ do
      post_factory = PostFactory.changeset(%PostFactory{}, %{name: "Brian"})
      post = Post.changeset(%Post{}, %{name: "Brian"})
      expected_error =
        {"should be at least %{count} character(s)",
         [count: 8, validation: :length, min: 8]}

      [post_factory: post_factory, post: post, expected_error: expected_error]
    end

    test "merge_errors/2 will merge the error from one changeset to the other",
         %{post_factory: post_factory, post: post, expected_error: expected} do
      result = Changeset.merge_errors(post_factory, post)

      assert post.errors[:name] == expected
      assert is_nil post_factory.errors[:name]
      assert result.errors[:name] == expected
      assert result.data == %PostFactory{}
    end

    test "merge_errors/2 will clear duplicate errors",
         %{post_factory: post_factory, post: post, expected_error: expected} do
      result =
        post_factory
        |> Changeset.merge_errors(post)
        |> Changeset.merge_errors(post)

      assert result.errors[:name] == expected
      assert result.data == %PostFactory{}
    end

    test "merge_errors/2 does not blow up if the 2nd param is not a changeset",
         %{post_factory: post_factory} do
      result = Changeset.merge_errors(post_factory, %Post{})
      assert result == post_factory
    end

    test "merge_errors/2 throws exception is the first item is not a changeset",
         %{post: post} do
      assert_raise FunctionClauseError, fn ->
        Changeset.merge_errors(%PostFactory{}, post)
      end
    end
  end
end
