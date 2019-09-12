defmodule Capture.Surveys do
  @moduledoc """
  The Surveys context.
  """

  import Ecto.Query, warn: false
  alias Capture.Repo

  alias Capture.Surveys.Response
  alias Capture.Surveys.Demographic

  def handle_response(params) do
    find_response(params)
    |> case do
      nil ->
        create_response(params)
      response ->
        update_response(response, params)
    end
  end

  def handle_demographic(demographic_map) do
    demographic_map |> IO.inspect(label: "CURRENT DEMO MAP: ")
    find_demographic(demographic_map)
    |> case do
      nil -> 
        demographic_map
        |> IO.inspect(label: "Inserting new demographic: ")
        |> create_demographic()
      demographic ->
        demographic |> IO.inspect(label: "Existing demographic: ")
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

  def create_demographic(attrs \\ %{}) do
    %Demographic{}
    |> Demographic.changeset(attrs)
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

  def parse_demographics(demographics_string) do
    demographics_string
    |> String.split("_")
    |> Enum.map(fn string_pair -> 
        list_pair = String.split(string_pair, "-") 
        %{name: Enum.at(list_pair, 0),value: Enum.at(list_pair, 1)  }
      end )
  end

  def find_demographic(%{
    value: value,
    name: name,
  }) do
    Demographic
    |> where(
      name: ^name,
      value: ^value,
    )
    |> Repo.one
  end

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
