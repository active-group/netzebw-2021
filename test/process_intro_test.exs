defmodule ProcessIntroTest do
  use ExUnit.Case, async: true


  setup do
    pid = spawn(ProcessIntro, :inc_server, [0])
    get_state_fn = fn pid ->
      send(pid, {:get, self()})
      receive do
        state -> state
      end
    end
    {:ok, %{server: pid, get_state: get_state_fn}}
  end

  describe "message :inc" do

    # test "increases the value by one", %{server: server, get_state: get_state} do
      # send(server, :inc)
      # send(server, :inc)
      # send(server, :inc)

      # assert 3 == get_state.(server)
    # end

    # test "decreases the value by one", %{server: server, get_state: get_state} do
      # send(server, :dec)
      # send(server, :dec)
      # send(server, :dec)

      # assert -3 == get_state.(server)
    # end

  end



end
