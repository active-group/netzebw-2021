defmodule PhoenixIntro.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :birthday, :date
    field :name, :string

    timestamps()
  end

  def name_validation(changeset) do
    changeset
    |> validate_required([:name, :birthday])
    |> validate_length(:name, min: 3)
  end
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :birthday])
    |> name_validation()
  end
end
