import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :phoenix_intro, PhoenixIntro.Repo,
  username: "postgres",
  password: "postgres",
  database: "phoenix_intro_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_intro, PhoenixIntroWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "H0iuBzVzju0liAMycX35q/8+r/9aFc/mjl+7ivqI+rn2EM7gKFboPIJFv2MD5+xX",
  server: false

# In test we don't send emails.
config :phoenix_intro, PhoenixIntro.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
