# Todo

> Todo App using Elixir/Phoenix, GraphQL and Postgres

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000/api/graphiql`](http://localhost:4000/api/graphiql) from your browser on dev envirnment.For production use `localhost:4000/api/`

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Installation Pre-Requisites

  * Elixir 1.14.3
  * Erlang OTP 24.0.4
  * Postgres

## Project Setup and Tutorial Instructions

1.  create the project

    ```zsh
    mix phx.new todo --no-html --no-assets
    ```

    Note: Reply 'Y' fetch and install dependencies.

    ```zsh
    cd todo
    ```

3.  Go to these two files and update Todo.Repo database credentials for postgres:

    ```text
    config/dev.exs
    config/test.exs
    ```

4.  create the db using mix command:

    ```zsh
    mix ecto.create
    ```

5.  generate schemas, and migrations for the `List` resource

    ```zsh
    mix phx.gen.schema List lists --binary-id title:string archived:boolean
    ```


6.  generate schemas, and migrations for the `Item` resource

    ```zsh
    mix phx.gen.schema Item items --binary-id list_id:references:lists --binary-id content:string completed:boolean
    ```

7.  migrate the database

    ```zsh
    mix ecto.migrate
    ```
    
8.  add below code to seeds file 
    `priv/repo/seeds.exs`:
    ```elixir
    alias Todo.List
	alias Todo.Item
	alias Todo.Repo

	# Adding data to List and Item
	%{id: list_id} = %List{title: "List 1"} |> Repo.insert!
	%Item{content: "List 1 Item 1", list_id: list_id} |> Repo.insert!

	%{id: list_id} = %List{title: "List 2"} |> Repo.insert!
	%Item{content: "List 2 Item 2", list_id: list_id} |> Repo.insert!
     ```
     and execute seeds to populate seeding data using mix command
     ```zsh
     mix run priv/repo/seeds.exs
     ```
9.   Add below Absinthe dependencies for Graphql integration in `mix.exs` file inside deps():

     ```elixir
      {:absinthe, "~> 1.6"},
      {:absinthe_plug, "~> 1.5"}
     ```
10.  Replace scope api code:

     ```elixir
     scope "/api", TodoWeb do
       pipe_through :api
     end
     ```
     with 
     ```elixir
	 scope "/api" do
		pipe_through :api

		if Mix.env == :dev do
		forward "/graphiql", Absinthe.Plug.GraphiQL,
			schema: TodoWeb.Schema
		end

		forward "/", Absinthe.Plug,
		schema: TodoWeb.Schema

	 end
     ```
     
11. Add Graphql schema file inside todo_web to import queries and mutation along with middleware to handle changeset error:

    `todo/lib/todo_web/schema.ex`

    ```elixir
	defmodule TodoWeb.Schema do
	use Absinthe.Schema
	alias SeWeb.GraphQL.Middleware

	import_types TodoWeb.Graphql.SchemaTypes

	query do
		import_fields :schema_queries
	end

	mutation do
		import_fields :schema_mutations
	end

	# exectute changeset error middleware for each mutation
	def middleware(middleware, _field, %{identifier: :mutation}) do
		middleware ++ [Middleware.ChangesetErrors]
	end

	def middleware(middleware, _field, _object) do
		middleware
	end
	end

    ```


12. Add graphql schema types and resolvers file seperately:

    `todo/lib/todo_web/graphql/schema_types.ex`

     ```elixir
	defmodule TodoWeb.Graphql.SchemaTypes do
	use Absinthe.Schema.Notation

	alias TodoWeb.Graphql.SchemaResolver

	object :schema_queries do
		@desc "Get all lists"
		field :all_lists, non_null(list_of(non_null(:list))) do
		resolve(&SchemaResolver.all_lists/3)
		end

		@desc "Get all list items"
		field :all_list_items, non_null(list_of(non_null(:item))) do
		arg :list_id, non_null(:id)
		resolve(&SchemaResolver.all_list_items/3)
		end
	end

	object :schema_mutations do
		field :create_list, non_null(list_of(non_null(:list))) do
		arg :title, non_null(:string)
		resolve(&SchemaResolver.create_list/3)
		end
		field :update_list, non_null(list_of(non_null(:list))) do
		arg :id, non_null(:id)
		arg :title, :string
		arg :archived, :boolean
		resolve(&SchemaResolver.update_list/3)
		end

		field :create_list_item, non_null(:item) do
		arg :content, non_null(:string)
		arg :list_id, non_null(:id)
		resolve(&SchemaResolver.create_list_item/3)
		end

		field :update_list_item, non_null(:item) do
		arg :id, non_null(:id)
		arg :content, :string
		arg :completed, :boolean
		arg :list_id, :id
		resolve(&SchemaResolver.update_list_item/3)
		end
	end

	object :list do
		field :id, non_null(:id)
		field :title, non_null(:string)
		field :archived, non_null(:boolean)
	end

	object :item do
		field :id, non_null(:id)
		field :content, non_null(:string)
		field :completed, non_null(:boolean)
		field :list_id, non_null(:id)
	end
	end
     
     ```

    `todo/lib/todo_web/graphql/schema_resolvers.ex`

     ```elixir
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

	def delete_list(_parent, %{id: list_id} = args, _info) do
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
     
     ```
     
13. Create List and Item implementation files inside todo folder:

    `todo/lib/todo/lists.ex`
     
     ```elixir
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
     
     ```

    `todo/lib/todo/items.ex`
     
     ```elixir
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
     
     ```
     
14.  Move database schema inside schema folder:
     i.e 
     	move `todo/lib/todo/list.ex` to `todo/lib/todo/schema/list.ex`
     	move `todo/lib/todo/item.ex` to `todo/lib/todo/schema/item.ex`

15. Add Changeset Error Handler Middleware inside graphql/middleware folder:
 `todo/lib/todo_web/graphql/middleware/changeset_errors.ex`:

     ```elixir
	defmodule SeWeb.GraphQL.Middleware.ChangesetErrors do
	@behaviour Absinthe.Middleware
	
	def call(resolution, _) do
		%{resolution |
		errors: Enum.flat_map(resolution.errors, &handle_error/1)
		}
	end

	defp handle_error(%Ecto.Changeset{} = changeset) do
		changeset
		|> Ecto.Changeset.traverse_errors(fn {err, _opts} -> err end)
		|> Enum.map(fn({k,v}) -> "#{k}: #{v}" end)
	end
	defp handle_error(error), do: [error]
	end
     ```
