defmodule Todo.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :string
      add :completed, :boolean, default: false, null: false
      add :list_id, references(:lists, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:items, [:list_id])
  end
end
