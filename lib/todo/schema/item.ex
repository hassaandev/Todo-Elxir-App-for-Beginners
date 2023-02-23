defmodule Todo.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "items" do
    field :completed, :boolean, default: false
    field :content, :string
    field :list_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:content, :completed])
    |> validate_required([:content, :completed])
  end
end
