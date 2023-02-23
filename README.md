# Todo

> Todo App with Auto-Cleanup using Elixir/Phoenix, GraphQL and Postgres

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Installation Pre-Requisites

  * Elixir 1.14.3
  * Erlang OTP 24.0.4
  * Postgres

## Tutorial Installation

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
    ```

6.  generate schemas, and migrations for the `Item` resource

    ```zsh
    mix phx.gen.schema Item items --binary-id list_id:references:lists --binary-id content:string completed:boolean
    ```

7.  migrate the database

    ```zsh
    mix ecto.migrate
    ```
