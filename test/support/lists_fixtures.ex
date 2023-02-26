defmodule Todo.ListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Lists` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        archived: false,
        title: "some title"
      })
      |> Todo.Lists.create_list()

    list
  end
end
