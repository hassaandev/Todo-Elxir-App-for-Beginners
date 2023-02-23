defmodule Todo.Lists do
  @moduledoc """
  	List related CRUDS.
  """

  import Ecto.Query, warn: false

  alias Todo.Repo
  alias Todo.List

  require Logger

  @doc """
  	Returns all the lists.
  """
  def list_lists do
    Repo.all(List)
  end

  @doc """
  	Gets a single list.
  """
  def get_list(id), do: Repo.get(List, id)

  @doc """
  	Creates a list.
  """
  def create_list(attrs \\ %{}) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
	  Updates a list.
  """
  def update_list(%List{} = list, attrs) do
      list
      |> List.update_changeset(attrs)
      |> Repo.update
  end

  @doc """
  	Deletes a List.
  """
  def delete_list(%List{} = record) do
    Repo.delete(record)
  end
end
