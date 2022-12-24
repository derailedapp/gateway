defmodule Derailed.Session.Registry do
  use GenServer
  require Logger

  def start_link(opts) do
    Logger.info "Starting up Session Registry"
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # API for clients
  @spec get_sessions(String.t) :: MapSet.t
  def get_sessions(user_id) do
    GenServer.call(__MODULE__, {:get_sessions, user_id})
  end

  @spec new_session(pid, String.t) :: MapSet.t
  def new_session(ws_pid, user_id) do
    GenServer.call(__MODULE__, {:new_session, ws_pid, user_id})
  end

  # internal
  def handle_call({:get_sessions, user_id}, _from, state) do
    if Map.has_key?(state, user_id) == true do
      {:reply, Map.get(state, user_id), nil}
    else
      {:reply, Map.put(state, user_id, MapSet.new()), nil}
    end
  end

  def handle_call({:new_session, ws_pid, user_id}, _from, state) do
    {:ok, pid} = Derailed.Session.start(ws_pid, user_id)
    {:reply, pid, state}
  end

  def init(_opts) do
    {:ok, %{}}
  end

end
