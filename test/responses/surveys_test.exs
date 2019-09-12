defmodule Capture.SurveysTest do
  use Capture.DataCase

  alias Capture.Surveys
  alias Capture.Surveys.Response

  describe "values_tally" do
    @response_1 %{"question_id" => 1, "survey_id" => 1, "user_id" => 1,"value" => 3}
    @response_2 %{"question_id" => 1, "survey_id" => 1, "user_id" => 2,"value" => 3}
    @response_3 %{"question_id" => 2, "survey_id" => 1, "user_id" => 2,"value" => 3}
    @response_4 %{"question_id" => 2, "survey_id" => 2, "user_id" => 1,"value" => 3}

    setup do
      %Response{} |> Response.changeset(@response_1) |> Repo.insert!
      %Response{} |> Response.changeset(@response_2) |> Repo.insert!
      %Response{} |> Response.changeset(@response_3) |> Repo.insert!
      %Response{} |> Response.changeset(@response_4) |> Repo.insert!
      :ok
    end

    test "counts the number of responses for each value, for given survey_id" do
      assert Surveys.values_tally(%{"survey_id" => 1}) == %{
          ones: 0,
          twos: 0,
          threes: 3,
          fours: 0,
          fives: 0,
        }
    end

    test "counts the number of responses for each value, for given survey_id and question_id" do
      assert Surveys.values_tally(%{"survey_id" => 1, "question_id" => 1}) == %{
          ones: 0,
          twos: 0,
          threes: 2,
          fours: 0,
          fives: 0,
        }
    end
  end
end
