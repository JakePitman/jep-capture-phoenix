defmodule Capture.Surveys.Demographic do
  import Ecto.Query, warn: false
  alias Capture.Repo
  use Ecto.Schema
  import Ecto.Changeset
  alias Capture.Surveys
  alias Capture.Surveys.Demographic

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

  def handle_demographic(demographic_map) do
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

  def create_demographic(attrs \\ %{}) do
    %Demographic{}
    |> Demographic.changeset(attrs)
    |> Repo.insert!()
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
