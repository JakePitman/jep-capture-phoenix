defmodule Capture.Surveys.Response do
  use Ecto.Schema
  import Ecto.Changeset
  alias Capture.Surveys

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

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:survey_id, :question_id, :user_id, :value])
    |> validate_required([:survey_id, :question_id, :user_id, :value])
  end

  def changeset_update_demographics(%{} = response, demographics) do
    response
    |> cast(%{}, @required_fields)
    # associate demographics to the response
    |> put_assoc(:demographics, demographics)
  end
end
