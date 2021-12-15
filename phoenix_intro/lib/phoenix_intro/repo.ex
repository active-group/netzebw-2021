defmodule PhoenixIntro.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_intro,
    adapter: Ecto.Adapters.Postgres
end
