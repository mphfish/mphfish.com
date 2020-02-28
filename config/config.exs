use Mix.Config

config :mphfish, MphfishWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6FrdExke1OlufcBNaVg0jMsWLOz8JcxXkVz+5i3qiAfbQurYAGwwWgx5vv+yCtLO",
  render_errors: [view: MphfishWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Mphfish.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "wBvlz+wZ"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
