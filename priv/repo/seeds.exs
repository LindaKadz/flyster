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
alias Flyster.Context.Events
alias Flyster.Events.EventType
alias Flyster.Repo

modules = [User, Role, EventType]

Enum.each(modules, fn module -> Repo.delete_all(module) end)

roles = ["Fire Dancer", "Lyra Performer", "Pole Dancer", "Silks Performer", "Other Dancer"]

Enum.each(roles, fn role -> Accounts.create_role(role) end)
IO.puts "Roles Created!"

event_types = ["Retreat", "Photoshoot", "Pole in the Park", "Pop Up", "Flash Mob"]

Enum.each(event_types, fn event -> Events.create_event_type(event) end)
IO.puts "Event Types Created!"
