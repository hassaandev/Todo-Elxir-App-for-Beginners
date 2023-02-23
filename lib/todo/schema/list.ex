defmodule Todo.List do
  use Ecto.Schema
  import Ecto.Changeset

  alias Todo.List

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "lists" do
    field :archived, :boolean, default: false
    field :title, :string

    timestamps()
  end

  @required_fields [:title]

  @optional_fields [:archived]

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def update_changeset(%List{} = record, params ) do
    record
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_list_not_archived(record, params)
  end

  def validate_list_not_archived(changeset, %{archived: true, title: _title}, %{archived: false, title: _new_title}) do
    changeset
  end

  def validate_list_not_archived(changeset, %{archived: true, title: title}, %{title: new_title}) when title != new_title do
    add_error(changeset, :archived, "Unable to update the title of archived list")
  end

  def validate_list_not_archived(changeset, _, _) do
    changeset
  end
end
