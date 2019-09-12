defmodule Capture.Surveys.Response do
  import Ecto.Query, warn: false
  alias Capture.Repo
  use Ecto.Schema
  import Ecto.Changeset
  alias Capture.Surveys
  alias Capture.Surveys.Response

  schema "responses" do
    field :question_id, :integer
    field :survey_id, :integer
    field :user_id, :integer
    field :value, :integer
    many_to_many(
      :demographics,
      Surveys.Demographic,
      join_through: "response_demographic",
      on_replace: :delete
    )

    timestamps()
  end

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

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:survey_id, :question_id, :user_id, :value])
    |> validate_required([:survey_id, :question_id, :user_id, :value])
  end

  def changeset_update_demographics(%{} = response, demographics) do
    response
    |> cast(%{}, @required_fields)
    |> IO.inspect(label: "CAST RESULT")
    # associate demographics to the response
    |> put_assoc(:demographics, demographics)
  end
end
