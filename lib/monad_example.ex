defmodule Maybe do
  @moduledoc """
  Ein Maybe ist eines der folgenden
  - Ein Wert `Just`
  - Kein Wert `None`
  """

  defmodule Just do
    alias __MODULE__

    @type t(inner_value) :: %Just{
            value: inner_value
          }
    defstruct [:value]
  end

  defmodule None do
    alias __MODULE__
    @type t :: %None{}
    defstruct []
  end

  @type t(inner_value) :: Just.t(inner_value) | None.t()

  @type bind_inner_value_t :: any()
  @type bind_result_value_t :: any()

  @spec bind(t(bind_inner_value_t()), (bind_inner_value_t() -> t(bind_result_value_t()))) :: t(bind_inner_value_t())
  def bind(m, foo) do
    case m do
      %Just{value: v} ->
        foo.(v)

      %None{} ->
        %None{}
    end
  end

  def return(v) do
    %Just{value: v}
  end

  def map(m, foo) do
    case m do
      %Just{value: v} -> %Just{value: foo.(v)}
      %None{} -> %None{}
    end
  end

  # das hier sind Beispielmethoden, damit die Datei kompiliert
  @spec get_user(any()) :: Maybe.t(any())
  def get_user(user_id), do: Maybe.return(user_id)

  @spec get_fav_book(any()) :: Maybe.t(any())
  def get_fav_book(user), do: Maybe.return(user)

  @spec get_author(any()) :: Maybe.t(any())
  def get_author(user), do: Maybe.return(user)

  @spec get_books_by_author(any()) :: Maybe.t(any())
  def get_books_by_author(user), do: Maybe.return(user)

  @spec get_user_favorite_books_authors_books(any()) :: any()
  def get_user_favorite_books_authors_books(user_id) do
    get_user(user_id)
    |> bind(fn user -> get_fav_book(user) end)
    |> bind(fn book -> get_author(book) end)
    |> bind(fn author -> get_books_by_author(author) end)
  end
end
