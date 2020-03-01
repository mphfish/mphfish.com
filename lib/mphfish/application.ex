defmodule Mphfish.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      MphfishWeb.Endpoint | additional_children()
    ]

    opts = [strategy: :one_for_one, name: Mphfish.Supervisor]
    Supervisor.start_link(children, opts)
  end

  case Mix.env() do
    :test ->
      defp additional_children, do: []

    _ ->
      defp additional_children,
        do: [
          {Mphfish.ArticleRepo,
           [[article_path: "#{Application.app_dir(:mphfish, "priv/articles")}/*.md"]]}
        ]
  end

  def config_change(changed, _new, removed) do
    MphfishWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
