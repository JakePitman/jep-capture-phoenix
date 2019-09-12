defmodule CaptureWeb.ResponseController do
  use CaptureWeb, :controller

  alias Capture.Surveys
  alias Capture.Surveys.Response
  alias Capture.Surveys.Demographic

  action_fallback CaptureWeb.FallbackController

  def create(conn, %{
    "survey_id" => _survey_id,
    "question_id" => _question_id,
    "user_id" => _user_id,
    "value" => value
  } = params) do
    {:ok, %Response{} = response} = params
    |> Response.handle_response

    unless is_nil(params["demographics"]) do
      demographics = Demographic.parse_demographics(params["demographics"])
      |> Enum.map(fn demographic -> Demographic.handle_demographic(demographic) end)
      response |> Response.associate_with_demographics(demographics)
    end

    conn
    |> put_status(:created)
    |> put_resp_header("location", Routes.response_path(conn, :show, response))
    |> render("show.json", response: response)
  end

  def show(conn, %{"id" => id}) do
    response = Response.find_response(id)
    conn
    |> render("show.json", response: response)
  end
end
