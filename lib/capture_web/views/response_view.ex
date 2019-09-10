defmodule CaptureWeb.ResponseView do
  use CaptureWeb, :view
  alias CaptureWeb.ResponseView

  def render("show.json", %{response: response}) do
    %{data: render_one(response, ResponseView, "response.json")}
  end

  def render("response.json", %{response: response}) do
    %{id: response.id,
      survey_id: response.survey_id,
      question_id: response.question_id,
      user_id: response.user_id,
      value: response.value}
  end
end
