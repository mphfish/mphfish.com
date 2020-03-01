defmodule MphfishWeb.ArticleController do
  use MphfishWeb, :controller

  def all(conn, _params) do
    render(conn, "article_list.html", articles: Mphfish.ArticleRepo.all())
  end

  @spec article(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def article(conn, %{"article_name" => article_name}) do
    case Mphfish.ArticleRepo.get(article_name) do
      %{has_content: true, is_draft: false} = article ->
        conn
        |> assign(:title_suffix, article.short_title)
        |> render_article(article)

      _ ->
        not_found(conn)
    end
  end

  def article(conn, _params), do: not_found(conn)

  defp render_article(conn, article) do
    render(conn, "article.html", %{article: article})
  end

  def not_found(conn, _params \\ nil) do
    conn
    |> put_view(Mphfish.ErrorView)
    |> put_status(404)
    |> render("404.html")
  end
end
