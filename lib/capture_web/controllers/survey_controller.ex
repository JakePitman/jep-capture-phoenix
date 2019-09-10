defmodule CaptureWeb.SurveyController do
  use CaptureWeb, :controller
  # action_fallback CaptureWeb.FallbackController
  alias Capture.Surveys

  def show(conn, %{"survey_id" => _} = params) do
    values_tally = Surveys.values_tally(params)
    conn
    |> render("values_tally.json", values_tally: values_tally)
  end
end