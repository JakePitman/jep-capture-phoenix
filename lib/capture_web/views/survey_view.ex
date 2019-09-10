defmodule CaptureWeb.SurveyView do
  use CaptureWeb, :view
  alias CaptureWeb.SurveyView

  def render("values_tally.json", %{values_tally: values_tally}) do
    values_tally
  end
end

