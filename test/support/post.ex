defmodule PT.Test.Support.Post do
  @moduledoc """
  A very simple model for testing PT tools.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(name)a

  schema "posts" do
    field(:name, :string)

    timestamps()
  end

  @spec changeset(Schema.t | Changeset.t, map) :: Changeset.t
  def changeset(struct, post) do
    struct
    |> cast(post, ~w(name))
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 8, max: 255)
  end
end
