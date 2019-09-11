defmodule Capture.Repo.Migrations.CreateResponsesDemographicsTable do
  use Ecto.Migration

  def change do
    create table(:response_demographic, primary_key: false) do
      add(:response_id, references(:responses, on_delete: :delete_all), primary_key: true)
      add(:demographic_id, references(:demographics, on_delete: :delete_all), primary_key: true)
      timestamps()
    end

    create(index(:response_demographic, [:response_id]))
    create(index(:response_demographic, [:demographic_id]))

    create(
      unique_index(:response_demographic, [:response_id, :demographic_id], name: :response_id_demographic_id_unique_index)
    )
  end
end
