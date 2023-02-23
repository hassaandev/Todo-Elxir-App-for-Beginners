# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

alias Todo.List
alias Todo.Item
alias Todo.Repo

# Adding data to List and Item
%{id: list_id} = %List{title: "List 1"} |> Repo.insert!
%Item{content: "List 1 Item 1", list_id: list_id} |> Repo.insert!

%{id: list_id} = %List{title: "List 2"} |> Repo.insert!
%Item{content: "List 2 Item 2", list_id: list_id} |> Repo.insert!
