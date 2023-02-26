defmodule Todo.ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Items` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    list  = Todo.ListsFixtures.list_fixture()
    {:ok, item} =
      attrs
      |> Enum.into(%{
        list_id: list.id,
        completed: true,
        content: "some content"
      })
      |> Todo.Items.create_list_item()

    item
  end
end
