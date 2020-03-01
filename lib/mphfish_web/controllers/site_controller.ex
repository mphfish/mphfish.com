defmodule MphfishWeb.SiteController do
  use MphfishWeb, :controller

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def privacy_policy(conn, _params) do
    render(conn, "privacy.html")
  end
end
