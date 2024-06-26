defmodule Todo.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :archived, :boolean, default: false, null: false

      timestamps()
    end
  end
end
