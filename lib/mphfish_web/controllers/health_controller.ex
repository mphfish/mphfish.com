defmodule MphfishWeb.HealthController do
  use MphfishWeb, :controller

  def health(conn, _params) do
    put_status(conn, 200)
  end
end
