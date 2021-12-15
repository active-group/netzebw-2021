defmodule IncServer do
  alias __MODULE__
  use GenServer

  def start_link(arg, opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(IncServer, arg, name: name)
  end


  @impl GenServer
  def init(arg) do
    {:ok, arg}
  end

  @spec get(GenServer.server()) :: number()
  def get(name \\ __MODULE__) do
    GenServer.call(name, :get)
  end

  @spec inc!(GenServer.server()) :: :ok
  def inc!(name \\ __MODULE__) do
    GenServer.cast(name, :inc)
  end

  @spec dec!(GenServer.server()) :: :ok
  def dec!(name \\ __MODULE__) do
    GenServer.cast(name, :dec)
  end


  @impl GenServer
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end


  @impl GenServer
  def handle_cast(:inc, state) do
    new_state = state + 1
    {:noreply, new_state}
  end

  @impl GenServer
  def handle_cast(:dec, state) do
    new_state = state - 1
    {:noreply, new_state}
  end

end
