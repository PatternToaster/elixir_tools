defmodule PT.Changeset do
  @moduledoc """
  Adds functionality to Ecto.Changeset for StatusRepo
  """

  alias Ecto.Changeset
  alias Ecto.Schema

  @type data :: Changeset.data
  @type types :: Changeset.types
  @type error_tuple :: {atom, {String.t, keyword}}

  @doc """
  Given two changesets - adds the errors from &2 in to &1.

  If &2 is not a changeset - returns &1.

  In certain contexts we'll want to present a context-dependant schema which
  maps to some number of tables behind the scenes. We can perform server-side
  data validation on this "composite" type - however those validations wouldn't
  include database constraints until we generate the table-bound schemas and
  try an update/insert.

  This method allows us to add the table-bound errors back in to the original
  changeset from the composite type.

  ## Example

    iex> alias Hello.Membership.Registration
    ...> registration_changeset = Registration.changeset(%Registration{}, params)
    ...>
    ...> {user_result, user} = registration_changeset
    ...>                       |> Registration.to_user_changeset
    ...>                       |> insert!
    ...> {team_result, team} = registration_changeset
    ...>                       |> Registration.to_team_changeset
    ...>                       |> insert!
    ...>
    ...> if user_result == :ok && team_result == :ok do
    ...>   user
    ...> else
    ...>   registration_changeset
    ...>   |> PT.Changeset.merge_errors(user)
    ...>   |> PT.Changeset.merge_errors(team)
    ...> end
  """
  @spec merge_errors(Changeset.t, Schema.t | Changeset.t) :: Changeset.t
  def merge_errors(%Changeset{} = to_changeset, %Changeset{} = from_changeset) do
    changeset =
      Enum.reduce(from_changeset.errors, to_changeset, &_merge_errors/2)

    changeset
    |> Map.put(:errors, Enum.uniq(changeset.errors))
    |> Map.put(:action, from_changeset.action)
  end

  def merge_errors(%Changeset{} = to_changeset, _),
      do: to_changeset

  @spec merge_errors(error_tuple, Changeset.t) :: Changeset.t
  defp _merge_errors({key, {error, meta}}, to_changeset),
       do: Changeset.add_error(to_changeset, key, error, meta)
end
