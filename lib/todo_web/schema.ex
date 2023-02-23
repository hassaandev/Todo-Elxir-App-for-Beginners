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
