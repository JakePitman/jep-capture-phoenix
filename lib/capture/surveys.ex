defmodule Capture.Surveys do
  @moduledoc """
  The Surveys context.
  """

  import Ecto.Query, warn: false
  alias Capture.Repo

  alias Capture.Surveys.Response

  def handle_response(params) do
    find_response(params)
    |> case do
      nil ->
        create_response(params)
      response ->
        update_response(response, params)
      end
    end


  @doc """
  Creates a response.

  ## Examples

      iex> create_response(%{field: value})
      {:ok, %Response{}}

      iex> create_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_response(attrs \\ %{}) do
    %Response{}
    |> Response.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a response.

  ## Examples

      iex> update_response(response, %{field: new_value})
      {:ok, %Response{}}

      iex> update_response(response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_response(%Response{} = response, attrs) do
    response
    |> Response.changeset(attrs)
    |> Repo.update()
  end

  def find_response(%{
    "survey_id" => survey_id,
    "question_id" => question_id,
    "user_id" => user_id
  }) do
    Response
    |> where(
      survey_id: ^survey_id,
      question_id: ^question_id,
      user_id: ^user_id
    )
    |> Repo.one
  end

  def find_response(id) do
    Response
    |> where(
      id: ^id
    )
    |> Repo.one
  end

  def survey_answers(survey_id) do
    %{
      ones: count_value_total(survey_id, 1),
      twos: count_value_total(survey_id, 2),
      threes: count_value_total(survey_id, 3),
      fours: count_value_total(survey_id, 4),
      fives: count_value_total(survey_id, 5),
    }
  end

  defp count_value_total(survey_id, value) do
    Response
    |> where(
      survey_id: ^survey_id,
      value: ^value
    )
    |> Repo.all
    |> Enum.count
  end
end
