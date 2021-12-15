defmodule AdvancedTimeTest do

  use ExUnit.Case
  doctest AdvancedTime


  setup do
    {:ok, %{test_time: %AdvancedTime{hours: 2, minutes: 18, attribute: :twentyfour, utc_hour_offset: 0}}}
  end

  describe "make/2" do

    test "constructs a valid time", %{test_time: test_time} do
      time = AdvancedTime.make(2, 18)
      assert {:ok, test_time} == time

      time = AdvancedTime.make(0, 0)
      assert {:ok, %AdvancedTime{hours: 0, minutes: 0, attribute: :twentyfour, utc_hour_offset: 0}} == time
    end

  end

  describe "make!/2" do
    test "raises when minutes are out of range", _context do
      assert_raise RuntimeError, "hours_out_of_range", fn ->
        AdvancedTime.make!(100, 2)
      end
    end

    test "raises when hours are out of range", _context do
      assert_raise RuntimeError, "minutes_out_of_range", fn ->
        AdvancedTime.make!(2, 200)
      end
    end
  end

  describe "minutes_after_midnight/1" do
    test "calcuates minutes after midnight correctly for twentyfour-format" do
      time = AdvancedTime.make!(0, 0)
      assert AdvancedTime.minutes_after_midnight(time) == 0

      time = AdvancedTime.make!(2, 21)
      assert AdvancedTime.minutes_after_midnight(time) == 141
    end

    test "calcuates minutes after midnight correctly for am-format" do
      time = AdvancedTime.make!(0, 0, twelve_hour_period: :am)
      assert AdvancedTime.minutes_after_midnight(time) == 0

      time = AdvancedTime.make!(2, 21, twelve_hour_period: :am)
      assert AdvancedTime.minutes_after_midnight(time) == 141
    end

    test "calcuates minutes after midnight correctly for pm-format" do
      time = AdvancedTime.make!(0, 0, twelve_hour_period: :pm)
      assert AdvancedTime.minutes_after_midnight(time) == 12 * 60

      time = AdvancedTime.make!(2, 21, twelve_hour_period: :pm)
      assert AdvancedTime.minutes_after_midnight(time) == 14 * 60 + 21
    end
  end

end
