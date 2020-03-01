defmodule Mphfish.ArticleRepo do
  @moduledoc false
  @behaviour GenServer
  require Logger

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {
        __MODULE__,
        :start_link,
        opts
      },
      restart: :permanent,
      shutdown: 5000,
      type: :worker
    }
  end

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # public api

  @spec all() :: [Article.t()]
  def all() do
    :articles
    |> :ets.tab2list()
    |> Enum.map(&elem(&1, 1))
  end

  @spec get(String.t()) :: Article.t() | nil
  def get(slug) do
    case :ets.lookup(:articles, slug) do
      [{^slug, article} | _rest] -> article
      [] -> nil
    end
  end

  # GenServer callbacks
  def init(opts) do
    generate_table()
    warm_cache(Keyword.get(opts, :article_path))

    {:ok, opts}
  end

  defp warm_cache(path_glob) do
    log("warming cache")

    articles =
      path_glob
      |> Path.wildcard()
      |> Enum.map(fn article_path ->
        %Mphfish.Article{slug: slug} =
          article =
          article_path
          |> File.read!()
          |> Mphfish.Article.compile()

        {slug, article}
      end)

    log("adding #{length(articles)} to cache")

    :ets.insert(:articles, articles)
  end

  defp generate_table do
    :ets.new(:articles, [:set, :protected, :named_table])
  end

  defp log(message) do
    Logger.info("[article_repo] - #{message}", ansi_color: :green)
  end
end
