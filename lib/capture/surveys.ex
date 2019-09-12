defmodule Capture.Surveys do
  @moduledoc """
  The Surveys context.
  """

  import Ecto.Query, warn: false
  alias Capture.Repo

  alias Capture.Surveys.Response
  alias Capture.Surveys.Demographic


  def values_tally(%{"survey_id" => survey_id} = params) do
    %{
      ones: count_value_total(params, 1),
      twos: count_value_total(params, 2),
      threes: count_value_total(params, 3),
      fours: count_value_total(params, 4),
      fives: count_value_total(params, 5),
    }
  end

  defp count_value_total(%{"survey_id" => survey_id} = params, value) do
    count_value_total_query(params, value) 
    |> Repo.all
    |> Enum.count
  end

  def count_value_total_query(%{"survey_id" => survey_id, "question_id" => question_id} = params, value) do 
    count_value_total_query(%{"survey_id" => survey_id}, value)
    |> where( question_id: ^question_id) 
  end

  def count_value_total_query(%{"survey_id" => survey_id} = params, value) do 
    Response 
    |> where(
      survey_id: ^survey_id,
      value: ^value
    ) 
  end
end
