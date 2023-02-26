defmodule Todo.ListsTest do
  use Todo.DataCase

  alias Todo.Lists

  describe "lists" do
    alias Todo.List

    import Todo.ListsFixtures

    @invalid_attrs %{archived: "item", title: false}

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Lists.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Lists.get_list(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      valid_attrs = %{archived: true, title: "some title"}

      assert {:ok, %List{} = list} = Lists.create_list(valid_attrs)
      assert list.archived == true
      assert list.title == "some title"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lists.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data unarchive/updates the list" do
      list = list_fixture(%{archive: true})
      update_attrs = %{archived: false, title: "some updated title"}

      assert {:ok, %List{} = list} = Lists.update_list(list, update_attrs)
      assert list.archived == false
      assert list.title == "some updated title"
    end

    test "update_list/2 to update the title of an archive list should fail!" do
      list = list_fixture(%{archived: true})
      update_attrs = %{title: "some updated title"}

      assert {:error, %Ecto.Changeset{}} = Lists.update_list(list, update_attrs)
    end

    test "update_list/2 with valid data archive/updates the list" do
      list = list_fixture()
      update_attrs = %{archived: true, title: "some updated title"}

      assert {:ok, %List{} = list} = Lists.update_list(list, update_attrs)
      assert list.archived == true
      assert list.title == "some updated title"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Lists.update_list(list, @invalid_attrs)
      assert list == Lists.get_list(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Lists.delete_list(list)
      refute Lists.get_list(list.id)
    end

    # test "change_list/1 returns a list changeset" do
    #   list = list_fixture()
    #   assert %Ecto.Changeset{} = Lists.change_list(list)
    # end
  end
end
