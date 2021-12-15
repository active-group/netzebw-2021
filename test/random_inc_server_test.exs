defmodule RandomIncServerTest do
  use ExUnit.Case

  describe "inc/1" do

    test "does increment by a random number" do

      rand_fn = fn _ -> 2 end

      RandomIncServer.start_link(0, name: :inc_1_1, rand_fn: rand_fn)

      assert RandomIncServer.get(:inc_1_1) == 0
      RandomIncServer.inc!(:inc_1_1)
      assert RandomIncServer.get(:inc_1_1) == 2

    end

    test "does decrement by a random number" do

      rand_fn = fn _ -> 2 end

      RandomIncServer.start_link(0, name: :dec_1_1, rand_fn: rand_fn)

      assert RandomIncServer.get(:dec_1_1) == 0
      RandomIncServer.dec!(:dec_1_1)
      assert RandomIncServer.get(:dec_1_1) == -2

    end

  end

end
