defmodule PhoenixIntro.UserStatusService do
  use GenServer

  @type state_t() :: map()


  def put(server \\ __MODULE__, user_id, status) do
    GenServer.cast(server, {:put, user_id, status})
  end

  def get(server \\ __MODULE__, user_id) do
    GenServer.call(server, {:get, user_id})
  end

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, [], name: name)
  end

  @spec init(any) :: {:ok, state_t()}
  def init(_) do
    {:ok, %{}}
  end

  def handle_cast({:put, user_id, status}, state) do
    {:noreply, Map.put(state, user_id, status)}
  end

  def handle_call({:get, user_id}, _from, state) do
    {:reply, Map.get(state, user_id), state}
  end
end
