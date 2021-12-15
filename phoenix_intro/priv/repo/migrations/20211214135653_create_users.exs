defmodule PhoenixIntro.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :birthday, :date

      timestamps()
    end
  end
end
