defmodule CaptureWeb.SurveyController do
  use CaptureWeb, :controller
  # action_fallback CaptureWeb.FallbackController
  alias Capture.Surveys

  def show(conn, %{"id" => id}) do
    survey_answers = Surveys.survey_answers(id)
    conn
    |> render("survey.json", survey_answers: survey_answers)
  end
end