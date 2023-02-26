defmodule Todo.ItemsTest do
  use Todo.DataCase

  alias Todo.Items

  describe "items" do
    alias Todo.Item

    import Todo.ItemsFixtures

    @invalid_attrs %{completed: "null", content: true}

    test "list_items/1 returns all items of list id" do
      item = item_fixture()
      assert Items.list_items(item.list_id) == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Items.get_list_item(item.id) == item
    end

    test "create_list_item/1 with valid data creates a item" do
      list  = Todo.ListsFixtures.list_fixture()
      valid_attrs = %{completed: true, content: "some content", list_id: list.id}

      assert {:ok, %Item{} = item} = Items.create_list_item(valid_attrs)
      assert item.completed == true
      assert item.content == "some content"
    end

    test "create_list_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Items.create_list_item(@invalid_attrs)
    end

    test "create_list_item/1 with archived list data returns error" do
      list  = Todo.ListsFixtures.list_fixture(%{archived: true})
      archived_list_item = %{completed: true, content: "some content", list_id: list.id}

      assert {:error, %Ecto.Changeset{}} = Items.create_list_item(archived_list_item)
    end

    test "delete_list_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Items.delete_list_item(item)
      refute Items.get_list_item(item.id)
    end

    # test "change_item/1 returns a item changeset" do
    #   item = item_fixture()
    #   assert %Ecto.Changeset{} = Items.change_item(item)
    # end
  end
end
