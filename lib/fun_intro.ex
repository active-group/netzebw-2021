defmodule FunIntro do
  @moduledoc """
  Documentation for `FunIntro`.
  """

  defmodule Time do

    alias __MODULE__

    # Eine Uhrzeit besteht aus
    # - Stunden
    # - Minuten

    @type hours_t :: 0..23
    @type minutes_t :: 0..59

    @type t :: %Time{
      hours: hours_t(),
      minutes: minutes_t()
    }

    defstruct [:hours, :minutes]

    @spec make(hours_t(), minutes_t()) :: Time.t()
    def make(hours, minutes) do
      %Time{hours: hours, minutes: minutes}
    end

    @spec time1() :: Time.t()
    def time1() do
      make(8, 30)
    end

    @spec time2() :: Time.t()
    def time2() do
      make(0,0)
    end

    @doc """
    Berechnet die Minuten seit Mitternacht
      iex> FunIntro.Time.minutes_after_midnight(FunIntro.Time.time1())
      510
      iex> FunIntro.Time.minutes_after_midnight(FunIntro.Time.time2())
      0
    """

    @spec minutes_after_midnight(Time.t()) :: non_neg_integer()
    def minutes_after_midnight(time) do
      hours = time.hours
      minutes = time.minutes

      minutes + hours * 60
    end

    @doc """
    Erstellt eine Zeit aus den Minuten nach Mitternacht.
    iex> FunIntro.Time.time_of_minutes_after_midnight(150)
    %FunIntro.Time{hours: 2, minutes: 30}
    iex> minutes_after_midnight = FunIntro.Time.minutes_after_midnight(FunIntro.Time.time2())
    iex> FunIntro.Time.time_of_minutes_after_midnight(minutes_after_midnight)
    FunIntro.Time.time2()
    """

    @spec time_of_minutes_after_midnight(non_neg_integer()) :: Time.t()
    def time_of_minutes_after_midnight(minutes_after_midnight) do
      hours = div(minutes_after_midnight, 60)
      minutes = rem(minutes_after_midnight, 60)

      make(hours, minutes)
    end

    # TODO: Add doc and tests
    @spec with_no_minutes(Time.t()) :: Time.t()
    def with_no_minutes(time) do
      hours = time.hours
      make(hours, 0)
    end
  end


  defmodule Dillo do
    alias __MODULE__

    # Ein Gürteltier hat die folgenden Eigenschaften:
    # - lebendig oder tot
    # - Gewicht in g

    @type t :: %__MODULE__{
            alive?: boolean(),
            weight: pos_integer()
          }

    defstruct [:alive?, :weight]

    @spec make(boolean(), pos_integer()) :: Dillo.t()
    def make(alive?, weight) do
      %Dillo{alive?: alive?, weight: weight}
    end

    @spec dillo1() :: Dillo.t()
    def dillo1() do
      make(true, 15_000)
    end

    @spec dillo2() :: Dillo.t()
    def dillo2() do
      make(false, 25_000)
    end

    @doc """
    Überfährt ein Gürteltier

    iex> FunIntro.Dillo.run_over(FunIntro.Dillo.dillo1())
    FunIntro.Dillo.make(false, 15_000)

    iex> FunIntro.Dillo.run_over(FunIntro.Dillo.dillo2())
    FunIntro.Dillo.make(false, 25_000)
    """
    @spec run_over(Dillo.t()) :: Dillo.t()
    def run_over(dillo) do
      make(false, dillo.weight)
    end


    @doc """
    Gibt an, ob ein Wert ein Dillo ist oder nicht.
    Diese Funktion erfordert pattern-matching

    iex> FunIntro.Dillo.dillo?(FunIntro.Parrot.parrot1())
    false

    iex> FunIntro.Dillo.dillo?(FunIntro.Dillo.dillo1())
    true

    iex> FunIntro.Dillo.dillo?(12)
    false
    """

    @spec dillo?(any()) :: boolean()
    def dillo?(maybe_dillo) do
      case maybe_dillo do
        %Dillo{} -> true
        _ -> false
      end
    end

    @doc """
    iex> FunIntro.Dillo.feed(FunIntro.Dillo.dillo1(), 1000)
    %FunIntro.Dillo{weight: 16_000, alive?: true}

    iex> FunIntro.Dillo.feed(FunIntro.Dillo.dillo2(), 1000)
    %FunIntro.Dillo{weight: 25_000, alive?: false}
    """
    @spec feed(Dillo.t(), non_neg_integer()) :: Dillo.t()
    def feed(dillo, grams) do
      if dillo.alive? do
        make(true, dillo.weight + grams)
      else
        dillo
      end
    end
  end

  defmodule Parrot do
    @moduledoc """
      Modul definiert einen Papageien und bietet ...

      Ein Papagai hat folgende Eigenschaften
      - Gewicht in g
      - Satz, den er aufsagt
    """
    alias __MODULE__

    @type t :: %Parrot{
            weight: non_neg_integer(),
            # elixir type String.t()
            sentence: String.t()
          }

    defstruct [:weight, :sentence]

    @spec make(non_neg_integer(), String.t()) :: Parrot.t()
    def make(weight, sentence) do
      %Parrot{weight: weight, sentence: sentence}
    end

    @spec parrot1() :: Parrot.t()
    def parrot1() do
      make(100, "Arrr!")
    end

    @spec parrot2() :: Parrot.t()
    def parrot2() do
      # toter Papagei
      make(100, "")
    end

    @doc """
    Sagt, ob ein Papagei am Leben ist

    iex> FunIntro.Parrot.alive?(FunIntro.Parrot.parrot1())
    true

    iex> FunIntro.Parrot.alive?(FunIntro.Parrot.parrot2())
    false
    """

    @spec alive?(Parrot.t()) :: boolean()
    def alive?(parrot) do
      parrot.sentence != ""
    end

    @doc """
    Überfährt einen Papageien

    iex> p1 = FunIntro.Parrot.run_over(FunIntro.Parrot.parrot1())
    iex> FunIntro.Parrot.alive?(p1)
    false

    iex> p2 = FunIntro.Parrot.run_over(FunIntro.Parrot.parrot2())
    iex> FunIntro.Parrot.alive?(p2)
    false
    """
    @spec run_over(Parrot.t()) :: Parrot.t()
    def run_over(parrot) do
      make(parrot.weight, "")
    end

    @doc """
    Lässt einen Papageien etwas sagen
    """
    @spec say!(Parrot.t()) :: any()
    def say!(parrot) do
      if alive?(parrot) do
        IO.inspect(parrot.sentence)
      else
        IO.inspect("Leider tot!")
      end
    end

    @doc """
    Gibt an, ob ein Wert ein Papagei ist oder nicht.
    Wir benötigen hier pattern-matching

    iex> FunIntro.Parrot.parrot?(FunIntro.Parrot.parrot1())
    true

    iex> FunIntro.Parrot.parrot?(FunIntro.Dillo.dillo1())
    false

    iex> FunIntro.Parrot.parrot?(12)
    false
    """

    @spec parrot?(any()) :: boolean()
    def parrot?(maybe_parrot) do
      case maybe_parrot do
        %Parrot{} -> true
        _ -> false
      end
    end

    @doc """
    iex> FunIntro.Parrot.feed(FunIntro.Parrot.parrot1, 100)
    %FunIntro.Parrot{sentence: "Arrr!", weight: 200}

    iex> FunIntro.Parrot.feed(FunIntro.Parrot.parrot2, 100)
    %FunIntro.Parrot{sentence: "", weight: 100}
    """
    @spec feed(Parrot.t(), non_neg_integer()) :: Parrot.t()
    def feed(parrot, grams) do
      if alive?(parrot) do
        make(parrot.weight + grams, parrot.sentence)
      else
        parrot
      end
    end
  end

  defmodule Animal do
    @moduledoc """
      Ein Tier ist eines der folgenden:
      - ein Gürteltier
      - ein Papagei
    """

    @type t() :: Dillo.t() | Parrot.t()

    @doc """

    iex> FunIntro.Animal.animal?(FunIntro.Dillo.dillo1())
    true

    iex> FunIntro.Animal.animal?(FunIntro.Parrot.parrot1())
    true

    iex> FunIntro.Animal.animal?(12)
    false

    """

    @spec animal?(any()) :: boolean()
    def animal?(maybe_animal) do
      Dillo.dillo?(maybe_animal) || Parrot.parrot?(maybe_animal)
    end

    @doc """

    iex> FunIntro.Animal.run_over(FunIntro.Dillo.dillo1())
    %FunIntro.Dillo{weight: 15_000, alive?: false}

    iex> p = FunIntro.Animal.run_over(FunIntro.Parrot.parrot1())
    iex> FunIntro.Parrot.alive?(p)
    false
    """
    @spec run_over(Animal.t()) :: Animal.t()
    def run_over(animal) do
      cond do
        Dillo.dillo?(animal) -> Dillo.run_over(animal)
        Parrot.parrot?(animal) -> Parrot.run_over(animal)
      end
    end

    @doc """
    iex> FunIntro.Animal.alive?(FunIntro.Dillo.dillo1())
    true

    iex> FunIntro.Animal.alive?(FunIntro.Dillo.dillo2())
    false

    iex> FunIntro.Animal.alive?(FunIntro.Parrot.parrot1())
    true

    iex> FunIntro.Animal.alive?(FunIntro.Parrot.parrot2())
    false
    """
    @spec alive?(Animal.t()) :: Animal.t()
    def alive?(animal) do
      cond do
        Dillo.dillo?(animal) -> animal.alive?
        Parrot.parrot?(animal) -> Parrot.alive?(animal)
      end
    end

    # Implementiere alive? für die Tiere
    # Implementiere "füttere" die Tiere @spec feed(Dillo.t(), non_neg_integer()) :: Dillo.t(), wobei Gewicht + non_neg_integer

    # 1) Füttere das Gürteltier
    # 2) Füttere den Papageien
    # 3) Füttere ein Tier

    @doc """
    iex> dillo = FunIntro.Animal.feed(FunIntro.Dillo.dillo1(), 100)
    iex> dillo.weight
    15_100

    iex> parrot = FunIntro.Animal.feed(FunIntro.Parrot.parrot1(), 100)
    iex> parrot.weight
    200
    """
    @spec feed(Animal.t(), non_neg_integer()) :: Animal.t()
    def feed(animal, grams) do
      cond do
        Dillo.dillo?(animal) -> Dillo.feed(animal, grams)
        Parrot.parrot?(animal) -> Parrot.feed(animal, grams)
      end
    end
  end

  defmodule OurList do
    @moduledoc """
    Eine Liste ist eines der folgenden:

    - ein Cons
    - ein Empty
    """

    alias __MODULE__

    defmodule Empty do
      alias __MODULE__

      @type t :: %Empty{}
      defstruct []

      def make(), do: %Empty{}
    end

    defmodule Cons do
      alias __MODULE__

      @moduledoc """
      Eine Liste hat folgende Eigenschaften:
      - Ein element in first
      - Eine weitere Liste in rest
      """

      @type t() :: %Cons{
              first: any(),
              rest: FunIntro.OurList.t()
            }

      defstruct [:first, :rest]

    end

    @the_empty Empty.make()

    @type t :: Cons.t() | Empty.t()

    @spec empty?(any()) :: boolean()
    def empty?(%Empty{}), do: true
    def empty?(_), do: false

    @spec cons?(any()) :: boolean()
    def cons?(%Cons{}), do: true
    def cons?(_), do: false

    @spec cons(any, OurList.t()) :: Cons.t()
    def cons(first, rest) do
      %Cons{first: first, rest: rest}
    end

    @spec empty() :: Empty.t()
    def empty(), do: @the_empty

    @spec list1() :: OurList.t()
    def list1() do
      cons(1, cons(2, cons(3, empty())))
    end

    @spec list2() :: OurList.t()
    def list2() do
      cons("a", cons("b", cons("c", empty())))
    end

    @doc """
    Summiert die Elemente einer Liste
    iex> FunIntro.OurList.sum(FunIntro.OurList.list1)
    6

    iex> FunIntro.OurList.sum(FunIntro.OurList.empty())
    0
    """
    def sum(list) do
      cond do
        cons?(list) -> list.first + sum(list.rest)
        empty?(list) -> 0
      end
    end

    @spec multiply_helper(OurList.t()) :: integer()
    def multiply_helper(list) do
      cond do
        cons?(list) -> list.first * multiply_helper(list.rest)
        empty?(list) -> 1
      end
    end

    @doc """
    Multipliziert die Elemente einer Liste
    iex> FunIntro.OurList.multiply(FunIntro.OurList.list1)
    6

    iex> FunIntro.OurList.multiply(FunIntro.OurList.empty())
    0
    """
    @spec multiply(OurList.t()) :: integer()
    def multiply(list) do
      cond do
        cons?(list) -> multiply_helper(list)
        empty?(list) -> 0
      end
    end

    def even?(n), do: rem(n, 2) == 0

    @doc """
    Filtert alle geraden Zahlen aus einer Liste

    iex> FunIntro.OurList.filter_even(FunIntro.OurList.list1())
    FunIntro.OurList.cons(2, FunIntro.OurList.empty())

    iex> FunIntro.OurList.filter_even(FunIntro.OurList.empty())
    FunIntro.OurList.empty()
    """
    @spec filter_even(OurList.t()) :: OurList.t()
    def filter_even(list) do
      cond do
        cons?(list) ->
          first = list.first
          rest = filter_even(list.rest)

          if even?(first) do
            cons(first, rest)
          else
            rest
          end

        empty?(list) ->
          list
      end
    end

    @spec odd?(integer()) :: boolean()
    def odd?(n), do: !even?(n)

    @spec filter_odd(OurList.t()) :: OurList.t()
    def filter_odd(list) do
      cond do
        cons?(list) ->
          first = list.first
          rest = filter_odd(list.rest)

          if odd?(first) do
            cons(first, rest)
          else
            rest
          end

        empty?(list) ->
          list
      end
    end

    @doc """
    iex> FunIntro.OurList.filter(FunIntro.OurList.list1(), &FunIntro.OurList.even?/1)
    FunIntro.OurList.cons(2, FunIntro.OurList.empty())

    iex> FunIntro.OurList.filter(FunIntro.OurList.list1(), &FunIntro.OurList.odd?/1)
    FunIntro.OurList.cons(1, FunIntro.OurList.cons(3, FunIntro.OurList.empty()))
    """
    @spec filter(OurList.t(), (any() -> boolean())) :: OurList.t()
    def filter(list, pred?) do
      cond do
        cons?(list) ->
          first = list.first
          rest = filter(list.rest, pred?)

          if pred?.(first) do
            cons(first, rest)
          else
            rest
          end

        empty?(list) ->
          list
      end
    end

    @doc """
    Wendet eine gegebene Funktion fun auf jedes Element der Liste an

    iex> FunIntro.OurList.map(FunIntro.OurList.list1(), fn a -> a + 1 end)
    FunIntro.OurList.cons(2, FunIntro.OurList.cons(3, FunIntro.OurList.cons(4, FunIntro.OurList.empty())))

    iex> FunIntro.OurList.map(FunIntro.OurList.empty(), fn a -> a + 1 end)
    FunIntro.OurList.empty()
    """

    @spec map(OurList.t(), (any() -> any())) :: OurList.t()
    def map(list, fun) do
      cond do
        OurList.cons?(list) ->
          first = fun.(list.first)
          rest = map(list.rest, fun)

          OurList.cons(first, rest)

        OurList.empty?(list) ->
          list
      end
    end

    @doc """
    Hängt zwei Listen aneinander

    iex> FunIntro.OurList.append(FunIntro.OurList.list1(), FunIntro.OurList.list2())
    FunIntro.OurList.cons(
      1, FunIntro.OurList.cons(
        2, FunIntro.OurList.cons(
          3, FunIntro.OurList.cons(
            "a", FunIntro.OurList.cons(
              "b", FunIntro.OurList.cons(
                "c", FunIntro.OurList.empty()
                )
              )
            )
          )
        )
      )

    iex> FunIntro.OurList.append(FunIntro.OurList.empty(), FunIntro.OurList.empty())
    FunIntro.OurList.empty()
    """

    @spec append(OurList.t(), OurList.t()) :: OurList.t()
    def append(list1, list2) do
      case list1 do
        %Empty{} ->
          list2

        %Cons{first: first, rest: rest} ->
          cons(first, append(rest, list2))
      end
    end

    @doc """
    Reduziert eine liste auf einen Wert

    iex> FunIntro.OurList.reduce(FunIntro.OurList.list1(), 0, fn a, b -> a + b end)
    6

    iex> FunIntro.OurList.reduce(FunIntro.OurList.list1(), 1, fn a, b -> a * b end)
    6

    iex> FunIntro.OurList.reduce(FunIntro.OurList.list2(), "", fn a, b -> b <> a end)
    "abc"
    """

    @spec reduce(OurList.t(), any(), (any(), any() -> any())) :: any()
    def reduce(list, value, foo) do
      cond do
        cons?(list) ->
          first = list.first
          rest = list.rest

          next_value = foo.(first, value)
          reduce(rest, next_value, foo)

        empty?(list) ->
          value
      end
    end

    @spec reverse(OurList.t()) :: OurList.t()
    def reverse(list) do
      reduce(list, empty(), &cons/2)
    end

    @doc """
    iex> FunIntro.OurList.map_with_reduce(FunIntro.OurList.list1(), fn a -> a + 1 end)
    FunIntro.OurList.cons(
      2, FunIntro.OurList.cons(
        3, FunIntro.OurList.cons(
          4, FunIntro.OurList.empty()
        )
      )
    )
    """
    @spec map_with_reduce(OurList.t(), (any() -> any())) :: OurList.t()
    def map_with_reduce(list, foo) do
      foo_and_cons = fn el, list ->
        cons(foo.(el), list)
      end

      reduce(list, empty(), foo_and_cons)
      |> reverse()
    end

    @doc """
    iex> FunIntro.OurList.filter_with_reduce(FunIntro.OurList.list1(), &FunIntro.OurList.odd?/1)
    FunIntro.OurList.cons(
      1, FunIntro.OurList.cons(
        3, FunIntro.OurList.empty()
      )
    )

    iex> FunIntro.OurList.filter_with_reduce(FunIntro.OurList.list1(), &FunIntro.OurList.even?/1)
    FunIntro.OurList.cons(
      2, FunIntro.OurList.empty()
    )
    """

    @spec filter_with_reduce(OurList.t(), (any() -> boolean())) :: OurList.t()
    def filter_with_reduce(list, pred?) do
      filter_cons = fn el, list ->
        if pred?.(el) do
          cons(el, list)
        else
          list
        end
      end

      reduce(list, empty(), filter_cons)
      |> reverse()
    end
  end

  defmodule Highway do
    alias __MODULE__

    @moduledoc """
    Eine Autobahn ist eine Liste von Tieren
    """
    @type t :: OurList.t()

    @spec highway1 :: FunIntro.OurList.t()
    def highway1() do
      OurList.cons(
        Dillo.dillo1(),
        OurList.cons(
          Dillo.dillo2(),
          OurList.cons(
            Parrot.parrot1(),
            OurList.cons(
              Parrot.parrot2(),
              OurList.empty()
            )
          )
        )
      )
    end

    @spec highway2 :: FunIntro.OurList.t()
    def highway2() do
      OurList.empty()
    end

    # Aufgabe
    # 1) Eine Funktion, die alle Gürteltiere auf einem Highway zurückgibt
    # 2) Eine Funktion, die alle Papageien auf einem Highway zurückgibt
    # 3) Eine Funktion, die alle lebenden Tiere eines Highways zurückgibt

    @doc """
    Gibt alle Gürteltiere zurück, die sich auf dem Highway befinden

    iex> FunIntro.Highway.dillos(FunIntro.Highway.highway1())
    FunIntro.OurList.cons(FunIntro.Dillo.dillo1(),
      FunIntro.OurList.cons(FunIntro.Dillo.dillo2(),
        FunIntro.OurList.empty()))

    iex> FunIntro.Highway.dillos(FunIntro.Highway.highway2())
    FunIntro.OurList.empty()
    """
    @spec dillos(Highway.t()) :: Highway.t()
    def dillos(highway) do
      OurList.filter(highway, &Dillo.dillo?/1)
    end

    @doc """
    Gibt alle Papageien zurück, die sich auf dem Highway befinden

    iex> FunIntro.Highway.parrots(FunIntro.Highway.highway1())
    FunIntro.OurList.cons(FunIntro.Parrot.parrot1(),
      FunIntro.OurList.cons(FunIntro.Parrot.parrot2(),
        FunIntro.OurList.empty()))

    iex> FunIntro.Highway.parrots(FunIntro.Highway.highway2())
    FunIntro.OurList.empty()
    """
    @spec parrots(Highway.t()) :: Highway.t()
    def parrots(highway) do
      OurList.filter(highway, &Parrot.parrot?/1)
    end

    @doc """
    Gibt alle lebenden Tiere auf dem Highway zurück

    iex> FunIntro.Highway.alive(FunIntro.Highway.highway1())
    FunIntro.OurList.cons(FunIntro.Dillo.dillo1(),
      FunIntro.OurList.cons(FunIntro.Parrot.parrot1(),
        FunIntro.OurList.empty()))

    iex> FunIntro.Highway.alive(FunIntro.Highway.highway2())
    FunIntro.OurList.empty()
    """
    @spec alive(Highway.t()) :: Highway.t()
    def alive(highway) do
      OurList.filter(highway, &Animal.alive?/1)
    end

    @doc """
    Überfährt alle Tiere auf dem Highway

    iex> dead_animals = FunIntro.Highway.run_over_animals(FunIntro.Highway.highway1())
    iex> FunIntro.Highway.alive(dead_animals)
    FunIntro.OurList.empty()
    """

    @spec run_over_animals(Highway.t()) :: Highway.t()
    def run_over_animals(highway) do
      cond do
        OurList.cons?(highway) ->
          first = Animal.run_over(highway.first)
          rest = run_over_animals(highway.rest)

          OurList.cons(first, rest)

        OurList.empty?(highway) ->
          highway
      end
    end

    def run_over_animals_with_map(highway) do
      OurList.map(highway, &Animal.run_over/1)
    end

    @doc """
    Füttert alle Tiere auf dem Highway

    Ungetestet!
    """
    @spec feed_animals(Highway.t(), non_neg_integer()) :: Highway.t()
    def feed_animals(highway, grams) do
      cond do
        OurList.cons?(highway) ->
          first = Animal.feed(highway.first, grams)
          rest = feed_animals(highway.rest, grams)

          OurList.cons(first, rest)

        OurList.empty?(highway) ->
          highway
      end
    end

    def feed_animals_with_map(highway, grams) do
      f = fn animal -> Animal.feed(animal, grams) end
      OurList.map(highway, f)
    end

    @doc """
    Summiert das Gewicht aller Tiere

    iex> FunIntro.Highway.sum_of_animal_weights(FunIntro.Highway.highway1)
    15_000 + 25_000 + 100 + 100
    """
    def sum_of_animal_weights(highway) do
      highway
      |> OurList.map(fn animal -> animal.weight end)
      |> OurList.sum()
    end

    # TODO:
    # Sum all weights with reduce!

    def sum_of_animal_weight_with_reduce(highway) do
      OurList.reduce(highway, 0, fn animal, acc -> acc + animal.weight end)
    end

    def combine(highway1, highway2) do
      OurList.append(highway1, highway2)
    end

    def empty_highway(), do: OurList.empty()

  end


  # Protokolle

  defimpl Enumerable, for: OurList.Cons do
    @moduledoc """
    Implementiert Enumerable für unsere Listen
    """

    @impl Enumerable
    def count(_), do: {:error, __MODULE__}

    @impl Enumerable
    def member?(_, _), do: {:error, __MODULE__}

    @impl Enumerable
    def slice(_), do: {:error, __MODULE__}


    @impl Enumerable
    def reduce(list, {:cont, acc}, fun), do: {:done, OurList.reduce(list, acc, fun)}
    def reduce(_list, {:halt, acc}, _fun), do: {:halted, acc}
    def reduce(_list, {:suspend, acc}, _fun), do: {:suspended, acc}
  end


  defmodule TypesModule do

    def type_of(term) do
      cond do
          is_atom(term) -> "atom"
          is_boolean(term) -> "boolean"
          is_function(term) -> "function"
          is_list(term) -> "list"
          is_map(term) -> "map"
          is_nil(term) -> "nil"
          is_pid(term) -> "pid"
          is_port(term) -> "port"
          is_reference(term) -> "reference"
          is_tuple(term) -> "tuple"
          is_binary(term) -> "binary"
          is_bitstring(term) -> "bitstring"
          true -> :error
      end
    end

  end

  defprotocol Types do
    @fallback_to_any true
    @spec type_of(any()) :: String.t()
    def type_of(value)
  end

  defimpl Types, for: Any do
    def type_of(value), do: TypesModule.type_of(value)
  end

  defimpl Types, for: Integer do
    def type_of(_value), do: "integer"
  end

  defimpl Types, for: Atom do
    def type_of(_value), do: "atom"
  end

  defimpl Types, for: Dillo do
    def type_of(_value), do: "dillo"
  end


end
