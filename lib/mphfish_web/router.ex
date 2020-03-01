defmodule MphfishWeb.Router do
  use MphfishWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MphfishWeb do
    pipe_through :browser
    get "/privacy_policy", SiteController, :privacy_policy
    get "/about", SiteController, :about
  end

  scope "/api", MphfishWeb do
    pipe_through :api

    get "/health", HealthController, :health
  end
end
