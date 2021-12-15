defmodule RandomIncServer do
  alias __MODULE__
  use GenServer


  defmodule State do
    alias __MODULE__

    @type t :: %State{
      number: integer(),
      rand_fn: (integer() -> integer())
    }

    defstruct [:number, :rand_fn]

    def make(number, rand_fn) do
      %State{number: number, rand_fn: rand_fn}
    end
  end

  def start_link(arg, opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    rand_fn = Keyword.get(opts, :rand_fn, &:rand.uniform/1)
    GenServer.start_link(RandomIncServer, [arg, rand_fn], name: name)
  end


  @impl GenServer
  def init([initial_state, rand_fn]) do
    state = State.make(initial_state, rand_fn)
    {:ok, state}
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
  def handle_call(:get, _from, %State{number: number} = state) do
    {:reply, number, state}
  end


  @impl GenServer
  def handle_cast(:inc, %State{number: number, rand_fn: rand_fn} = state) do
    new_number = number + rand_fn.(10)
    {:noreply, %State{state | number: new_number}}
  end

  @impl GenServer
  def handle_cast(:dec, %State{number: number, rand_fn: rand_fn} = state) do
    new_number = number - rand_fn.(10)
    {:noreply, %State{state | number: new_number}}
  end

end
