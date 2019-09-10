defmodule Capture.SurveysTest do
  use Capture.DataCase

  alias Capture.Surveys
  alias Capture.Surveys.Response

  describe "responses, with no existing response" do
    @valid_attrs %{"question_id" => 42, "survey_id" => 42, "user_id" => 42,"value" => 42}

    test "handle_response/1 creates a new response" do
      assert {:ok, %Response{} = response} = Surveys.handle_response(@valid_attrs)
      assert response.question_id == 42
      assert response.survey_id == 42
      assert response.user_id == 42
      assert response.value == 42
    end
  end

  describe "responses, with an existing response" do
    @valid_attrs %{"question_id" => 42, "survey_id" => 42, "user_id" => 42,"value" => 42}

    setup do
      response = %Response{} |> Response.changeset(@valid_attrs) |> Repo.insert!
      {:ok, response: response}
    end

    test "handle_response/1, updates the existing response", %{response: response} do
      new_attrs = @valid_attrs |> Map.put("value", 1)
      assert {:ok, %Response{} = updated_response} = Surveys.handle_response(new_attrs)

      assert updated_response.id == response.id
      assert updated_response.value == 1
    end
  end

  describe "values_tally" do
    @response_1 %{"question_id" => 1, "survey_id" => 1, "user_id" => 1,"value" => 3}
    @response_2 %{"question_id" => 1, "survey_id" => 1, "user_id" => 2,"value" => 3}
    @response_3 %{"question_id" => 2, "survey_id" => 2, "user_id" => 1,"value" => 3}

    setup do
      response_1 = %Response{} |> Response.changeset(@response_1) |> Repo.insert!
      response_2 = %Response{} |> Response.changeset(@response_2) |> Repo.insert!
      response_3 = %Response{} |> Response.changeset(@response_3) |> Repo.insert!
      # I don't want this thing :/
      {:ok, response_1: response_1}
    end

    test "counts the number of responses for each value, for given survey_id" do
      assert Surveys.values_tally(%{"survey_id" => 1}) == %{
          ones: 0,
          twos: 0,
          threes: 2,
          fours: 0,
          fives: 0,
        }
    end
  end

  # describe "question_answers" do
  #   @response_1 %{"question_id" => 1, "survey_id" => 1, "user_id" => 1,"value" => 3}
  #   @response_2 %{"question_id" => 1, "survey_id" => 1, "user_id" => 2,"value" => 3}
  #   @response_3 %{"question_id" => 2, "survey_id" => 1, "user_id" => 1,"value" => 3}
  #   @response_4 %{"question_id" => 3, "survey_id" => 2, "user_id" => 1,"value" => 3}

  #   setup do
  #     response_1 = %Response{} |> Response.changeset(@response_1) |> Repo.insert!
  #     response_2 = %Response{} |> Response.changeset(@response_2) |> Repo.insert!
  #     response_3 = %Response{} |> Response.changeset(@response_3) |> Repo.insert!
  #     response_4 = %Response{} |> Response.changeset(@response_4) |> Repo.insert!
  #     {:ok, response_1: response_1}
  #   end

  #   test "counts the number of responses for each value, for given question_id" do
  #     assert Surveys.question_answers(1) == %{
  #         ones: 0,
  #         twos: 0,
  #         threes: 2,
  #         fours: 0,
  #         fives: 0,
  #       }
  #   end
  # end
end
