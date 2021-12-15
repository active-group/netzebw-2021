  defmodule AdvancedTime do
    alias __MODULE__
    @moduledoc """
    Zeit mit UTC offset und 12/24 Stunden Format

    Eine Uhrzeit besteht aus
    - Stunden
    - Minuten
    - Ein Format
    - Ein UTC-offset
    """

    @type hours_t :: 0..23 | 0..12
    @type minutes_t :: 0..59
    @type attribute_t :: :am | :pm | :twentyfour

    @type t :: %AdvancedTime{
            hours: hours_t(),
            minutes: minutes_t(),
            attribute: attribute_t(),
            utc_hour_offset: integer()
          }

    defstruct [:hours, :minutes, :attribute, :utc_hour_offset]

    @type error_t() :: {:error, :hours_out_of_range | :minutes_out_of_range | :unkown_format}

    @doc """
    Gibt an, ob es sich um ein valides Zeitformat/Attribut handelt.
    """
    defp valid_attribute?(:am), do: true
    defp valid_attribute?(:pm), do: true
    defp valid_attribute?(:twentyfour), do: true
    defp valid_attribute?(_), do: false


    @doc !"""
    Gibt an ob die angegebene Stundenanzahl im gegebenen Format gültig ist.
    """
    defp hour_in_range?(:am, hours) do
      hours < 12 and hours >= 0
    end

    defp hour_in_range?(:pm, hours) do
      hours < 12 and hours >= 0
    end

    defp hour_in_range?(:twentyfour, hours) do
      hours < 24 and hours >= 0
    end

    @doc !"""
    Gibt an ob die angegebene Minutenanzahl gültig ist.
    """
    defp minute_in_range?(minutes) do
      minutes < 60 and minutes >= 0
    end

    @type twelve_hour_period_opt_t :: {:twelve_hour_period, :am | :pm | :twentyfour}
    @type utc_offset_opt_t :: {:utc_hour_offset, integer()}

    @doc """
    Smart-constructor, überprüft Eingaben und optionale Argumente
    """
    @spec make(any, any, list(twelve_hour_period_opt_t() | utc_offset_opt_t())) :: {:ok, AdvancedTime.t()} | error_t()
    def make(hours, minutes, opts \\ []) do
      attribute = Keyword.get(opts, :twelve_hour_period, :twentyfour)
      offset = Keyword.get(opts, :utc_hour_offset, 0)

      cond do
        !valid_attribute?(attribute) ->
          {:error, :unknown_format}

        !hour_in_range?(attribute, hours) ->
          {:error, :hours_out_of_range}

        !minute_in_range?(minutes) ->
          {:error, :minutes_out_of_range}

        :default ->
          {:ok,
           %AdvancedTime{
             minutes: minutes,
             hours: hours,
             attribute: attribute,
             utc_hour_offset: offset
           }}
      end
    end

    @spec make!(any, any, list()) :: AdvancedTime.t()
    def make!(hours, minutes, opts \\ []) do
      case make(hours, minutes, opts) do
        {:error, err} -> raise RuntimeError, Atom.to_string(err)
        {:ok, time} -> time
      end
    end

    @spec time1() :: AdvancedTime.t()
    def time1() do
      make!(8, 30)
    end

    @spec time2() :: AdvancedTime.t()
    def time2() do
      make!(0, 0)
    end

    @spec hours_after_midnight(AdvancedTime.t()) :: integer()
    defp hours_after_midnight(%AdvancedTime{attribute: :pm, hours: hours}) do
      hours + 12
    end

    defp hours_after_midnight(%AdvancedTime{hours: hours}) do
      hours
    end

    @doc """
    Berechnet die Minuten seit Mitternacht

      iex> AdvancedTime.minutes_after_midnight(AdvancedTime.time1())
      510

      iex> AdvancedTime.minutes_after_midnight(AdvancedTime.time2())
      0
    """

    @spec minutes_after_midnight(AdvancedTime.t()) :: non_neg_integer()
    def minutes_after_midnight(time) do
      hours = hours_after_midnight(time)
      minutes = time.minutes

      minutes + hours * 60
    end

    # not implemented
    # @spec utc_minutes_after_midnight(AdvancedTime.t()) :: non_neg_integer()
    # def utc_minutes_after_midnight(time) do
    # end


    @doc """
    Erstellt eine Zeit aus den Minuten nach Mitternacht.

    iex> AdvancedTime.time_of_minutes_after_midnight(150)
    %AdvancedTime{attribute: :twentyfour, hours: 2, minutes: 30, utc_hour_offset: 0}

    iex> minutes_after_midnight = AdvancedTime.minutes_after_midnight(AdvancedTime.time2())
    iex> AdvancedTime.time_of_minutes_after_midnight(minutes_after_midnight)
    AdvancedTime.time2()
    """

    @spec time_of_minutes_after_midnight(non_neg_integer()) :: AdvancedTime.t()
    def time_of_minutes_after_midnight(minutes_after_midnight) do
      hours = div(minutes_after_midnight, 60)
      minutes = rem(minutes_after_midnight, 60)

      make!(hours, minutes)
    end
  end
