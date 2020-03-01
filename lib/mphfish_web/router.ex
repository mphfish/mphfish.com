defmodule MphfishWeb.Router do
  use MphfishWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", MphfishWeb do
    pipe_through :browser
    get "/privacy_policy", SiteController, :privacy_policy
    get "/about", SiteController, :about
  end

  end
end
