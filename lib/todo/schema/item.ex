defmodule Todo.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Todo.Item
  alias Todo.List
  alias Todo.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "items" do
    field :completed, :boolean, default: false
    field :content, :string
    field :list_id, :binary_id

    timestamps()
  end

  @required_fields [:content, :list_id]

  @optional_fields [:completed]

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_list_not_archived(attrs)
    |> foreign_key_constraint(:item, name: :items_list_id_fkey, message: "Couldn't create or update item, list doesn't exist.")
  end

  def update_changeset(%Item{} = record, params ) do
    record
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_list_not_archived(record)
  end

  def validate_list_not_archived(changeset, %{list_id: list_id}) do
    Repo.get(List, list_id)
    |> case do
      %{archived: false} -> changeset
      _ -> add_error(changeset, :list_id, "Unable to create/ update item under archived list")
    end
  end

  def validate_list_not_archived(changeset, _) do
    add_error(changeset, :list_id, "Unable to create an item without list")
  end
end
