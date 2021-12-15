defmodule PhoenixIntro.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixIntro.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        birthday: ~D[2021-12-13],
        name: "some name"
      })
      |> PhoenixIntro.Accounts.create_user()

    user
  end
end
