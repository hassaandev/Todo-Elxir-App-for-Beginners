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

    field :delete_list, non_null(list_of(non_null(:list))) do
      arg :id, non_null(:id)
      resolve(&SchemaResolver.delete_list/3)
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

    field :delete_list_item, non_null(:item) do
      arg :id, non_null(:id)
      resolve(&SchemaResolver.delete_list_item/3)
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
