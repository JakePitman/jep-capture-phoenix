defmodule Capture.ResponsesTest do
  use Capture.DataCase

  alias Capture.Surveys.Response

  describe "responses, with no existing response" do
    @valid_attrs %{"question_id" => 42, "survey_id" => 42, "user_id" => 42,"value" => 42}

    test "handle_response/1 creates a new response" do
      assert {:ok, %Response{} = response} = Response.handle_response(@valid_attrs)
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
      assert {:ok, %Response{} = updated_response} = Response.handle_response(new_attrs)

      assert updated_response.id == response.id
      assert updated_response.value == 1
    end
  end
end