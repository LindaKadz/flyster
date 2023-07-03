# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Flyster.Repo.insert!(%Flyster.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.]

alias Flyster.Accounts.User
alias Flyster.Accounts.Role
alias Flyster.Context.Accounts
alias Flyster.Repo

modules = [Role, User]

Enum.each(modules, fn module -> Repo.delete_all(module) end)

roles = ["Instructor", "Lyra Performer", "Photographer", "Pole Dancer", "Silks Performer", "Stripper"]

Enum.each(roles, fn role -> Accounts.create_role(role) end)
IO.puts "Roles Created!"
