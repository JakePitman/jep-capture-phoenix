defmodule CaptureWeb.SurveyView do
  use CaptureWeb, :view
  alias CaptureWeb.SurveyView

  def render("survey.json", %{survey_answers: survey_answers}) do
    survey_answers
  end
end

