defmodule Capture.Surveys.Demographic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Capture.Surveys

  schema "demographics" do
    field :name, :string
    field :value, :string
    many_to_many(
      :responses,
      Surveys.Response,
      join_through: "response_demographic",
      on_replace: :delete
    )
    
    timestamps()
  end

  @doc false
  def changeset(demographic, attrs) do
    demographic
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
  end

  # def upsert_response_demographics(response, project_ids) when is_list(project_ids) do
  #   projects =
  #     Project
  #     |> where([project], project.id in ^project_ids)
  #     |> Repo.all()

  #   with {:ok, _struct} <-
  #          response
  #          |> User.changeset_update_projects(projects)
  #          |> Repo.update() do
  #     {:ok, Accounts.get_user(user.id)}
  #   else
  #     error ->
  #       error
  #   end
  # end
end
