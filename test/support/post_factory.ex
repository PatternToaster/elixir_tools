defmodule PT.Test.Support.PostFactory do
  @moduledoc """
  A very simple model for testing PT tools.
  """

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
  end

  @spec changeset(Schema.t | Changeset.t, map) :: Changeset.t
  def changeset(struct, post), do: cast(struct, post, ~w(name))
end
