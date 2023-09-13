defmodule FlysterWeb.EventsNewLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events
  alias Flyster.Events.Event

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Create A New Event!
        <:subtitle>
          Your event type is not listed here? Send us an email at tech@spin.com and
          we'll add it! Having your event have an accurate event type helps us show
          your event to the relevant people and makes it appear on a search!
        </:subtitle>
      </.header>
    </div>

    <.simple_form
      for={@form}
      id="event_creation_form"
      phx-submit="save"
      phx-change="validate"
      phx-trigger-action={@trigger_submit}
      method="post"
    >
      <.error :if={@check_errors}>
        Oops, something went wrong! Please check the errors below.
      </.error>

      <div class="grid gap-6">
        <div>
          <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
            <p>
              <label for="name" class="bg-white text-gray-600 px-1">Event Name *</label>
            </p>
          </div>
          <p>
            <.input field={@form[:name]} type="text" required />
          </p>
        </div>
      </div>

        <div class="grid lg:grid-cols-2 gap-6">
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="event_type" class="bg-white text-gray-600 px-1">Event Type *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:event_type_id]} options={all_event_types()} type="select" label="" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="address" class="bg-white text-gray-600 px-1">Event Address *</label>

              </p>
            </div>
            <p>
              <.input field={@form[:location]} type="text" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="date" class="bg-white text-gray-600 px-1">Event Date *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:date]} type="text" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="time" class="bg-white text-gray-600 px-1">Starting Time *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:time]} type="text" inputmode="numeric" pattern="[0-9]*" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="currency" class="bg-white text-gray-600 px-1">Currency *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:currency]} type="text" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="price" class="bg-white text-gray-600 px-1">Price *</label>
                <span class="lowercase"> (Please state 0 if the event is free 😃)</span>
              </p>
            </div>
            <p>
              <.input field={@form[:price]} type="text" required />
            </p>
          </div>
        </div>

        <div class="grid gap-6">
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="description" class="bg-white text-gray-600 px-1">Description *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:description]} type="text" required />
            </p>
          </div>

          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="rules" class="bg-white text-gray-600 px-1">Rules *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:rules]} type="text" required />
            </p>
          </div>
        </div>

      <:actions>
        <div class="pt-3">
        <.button phx-disable-with="Doing our magic..."
        class="w-full rounded text-gray-100 bg-blue-500 hover:shadow-inner hover:bg-blue-700 transition-all duration-300">
          Create Event
        </.button>
        </div>
      </:actions>
    </.simple_form>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Events.change_event_creation(%Event{})
    IO.inspect socket

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  defp all_event_types do
    event_types = Events.all_event_types()
    Enum.map(event_types, &{&1.name, &1.id})
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "event")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset = Events.change_event_creation(%Event{}, event_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    params = Map.put(event_params, "host_id", socket.assigns.current_user.id)
    case Events.create_event(params) do
      {:ok, event} ->
        {:noreply,
          socket
          |> put_flash(:info, "#{event.name} has been successfully created!")
          |> redirect(to: ~p"/events/index")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end
end
