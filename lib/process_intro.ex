defmodule ProcessIntro do

    # OTP = open telecommunication platform

    def ping_pong(receiver) do
      receive do
        :ping ->
          send(receiver, :pong)
          ping_pong(receiver)
        :terminate -> nil
        _ -> raise "Unkown message"
      end
    end


    defmodule IncServerMessages do

      @type t :: Inc.t() | Dec.t() | Get.t()

      defmodule Inc do
        alias __MODULE__
        @type t :: %Inc{}
        defstruct []
      end

      defmodule Dec do
        alias __MODULE__
        @type t :: %Dec{}
        defstruct []
      end

      defmodule Get do
        alias __MODULE__
        @type t :: %Get{receiver: Process.dest()}
        defstruct [:receiver]
      end

    end

    @spec inc_server(number) :: no_return
    def inc_server(state) do
      receive do
        %IncServerMessages.Inc{} ->
          inc_server(state + 1)
        %IncServerMessages.Dec{} ->
          inc_server(state - 1)
        %IncServerMessages.Get{receiver: receiver} ->
          send(receiver, state)
          inc_server(state)
      end
    end



end
