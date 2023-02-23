defmodule TodoWeb.Graphql.SchemaResolver do
  alias Todo.Lists
  alias Todo.Items

  def all_lists(_root, _args, _info) do
    {:ok, Lists.list_lists()}
  end

  def create_list(_parent, args, _info) do
    Lists.create_list(args)
  end

  def update_list(_parent, %{id: list_id} = args, _info) do
    Lists.get_list(list_id)
    |> case do
      nil -> {:error, "List with id '#{list_id}' doesn't exist"}
      record -> Lists.update_list(record, args)

    end
  end

  def delete_list(_parent, %{id: list_id} = _args, _info) do
    Lists.get_list(list_id)
    |> case do
      nil -> {:error, "List with id '#{list_id}' doesn't exist"}
      record -> Lists.delete_list(record)

    end
  end

  def all_list_items(_root, %{list_id: list_id} = _args, _info) do
    {:ok, Items.list_items(list_id)}
  end

  def create_list_item(_parent, args, _info) do
    Items.create_list_item(args)
  end

  def update_list_item(_parent, %{id: item_id} = args, _info) do
    Items.get_list_item(item_id)
    |> case do
      nil -> {:error, "Item with id '#{item_id}' doesn't exist"}
      record -> Items.update_list_item(record, args)
    end
  end

  def delete_list_item(_parent, %{id: item_id} = _args, _info) do
    Items.get_list_item(item_id)
    |> case do
      nil -> {:error, "Item with id '#{item_id}' doesn't exist"}
      record -> Items.delete_list_item(record)
    end
  end
end
