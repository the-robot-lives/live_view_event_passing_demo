defmodule LiveViewEventPassingDemo.OTP.LiveViewDispatcher do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: {:global, __MODULE__})
  end

  @impl true
  def init(:ok) do
    :syn.add_node_to_scopes([:live_view_dispatch])
    {:ok, %{}}
  end

  def subscribe(session) do
    join = :syn.join(:live_view_dispatch, session, self())
    {join, session}
  end

  def publish(group, message) do
    :syn.publish(:live_view_dispatch, group, message)
  end

end



defmodule LiveViewEventPassingDemo.OTP.LiveViewDispatcher.Plug do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    case get_session(conn, :live_view_broadcaster_session) do
      nil ->
        # Generate a new session ID, for example a UUID
        new_session_id = UUID.uuid4()
        conn
        |> put_session(:live_view_broadcaster_session, new_session_id)

      _ ->
        conn
    end
  end
end
