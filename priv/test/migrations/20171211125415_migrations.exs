defmodule PT.Test.Repo.Migrations do
  use Ecto.Migration

  def up do
    create_if_not_exists table(:posts) do
      add(:name, :string)

      timestamps()
    end
  end

  def down do
    drop(table(:posts))
  end
end
