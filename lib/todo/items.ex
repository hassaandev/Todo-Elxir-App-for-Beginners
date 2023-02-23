defmodule Todo.Items do
  @moduledoc """
  The Items context.
  """

  import Ecto.Query, warn: false
  alias Todo.Repo

  alias Todo.Item
  require Logger

  @doc """
  	Returns all the items of list by list id.
  """
  def list_items(id) do
    query =
      from i in Item,
      where: i.list_id == ^id
    Repo.all(query)
  end

  @doc """
  	Get a single item by id.
  """
  def get_list_item(id), do: Repo.get(Item, id)

  @doc """
  	Create an item of list.
  """
  def create_list_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert(returning: true)
  end

  @doc """
  	Updates a item.
  """
  def update_list_item(%Item{} = record, attrs) do
    record
      |> Item.update_changeset(attrs)
      |> Repo.update(returning: true)
  end

  @doc """
  	Updates a item.
  """
  def update_item(%Item{} = item, attrs) do
    item = Repo.get!(Item, item.id)
    Repo.update(item, attrs)
  end

  @doc """
  Deletes an Item.
  """
  def delete_list_item(%Item{} = record) do
    Repo.delete(record)
  end
end
