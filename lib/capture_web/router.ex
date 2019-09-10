defmodule CaptureWeb.Router do
  use CaptureWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CaptureWeb do
    pipe_through :api
    resources "/responses", ResponseController, only: [:create, :show]
    get "/surveys/:survey_id", SurveyController, :show
    get "/surveys/:survey_id/questions/:question_id", SurveyController, :show

  end
end
