defmodule PT.Repo do
  @moduledoc """
  Adds functionality to Ecto.Repo for PatternToaster applications.

  This module expects to be used the same as Ecto.Repo.
  View [the Ecto docs](https://hexdocs.pm/ecto/Ecto.Repo.html) for more
    information.

  Example:

  ```
  defmodule PT.Test.Repo do
    use PT.Repo, otp_app: :pattern_toaster
  end
  ```
  """

  defmacro __using__(otp_app: repo) when is_atom(repo) do
    quote do
      use Ecto.Repo, otp_app: unquote(repo)

      @doc """
      Fetches a single result from the query and returns a tagged tuple.

      Returns a tagged tuple if no result was found.

      ## Options

      See the [“Shared options”](Shared options) section for the Ecto.Repo behaviour

      ## Example

      iex> SR.Repo.fetch_by(Post, title: "My post")
      {:ok, %Post{id: 1, title: "My post"}}
      """
      @spec fetch_by(Ecto.Queryable.t, Keyword.t | map, Keyword.t) ::
            {:ok, Ecto.Schema.t} | {:not_found, Ecto.Queryable.t}
      def fetch_by(queryable, clauses, opts \\ []) do
        case get_by(queryable, clauses, opts) do
          nil -> {:not_found, queryable}
          obj -> {:ok, obj}
        end
      end
    end
  end
end
