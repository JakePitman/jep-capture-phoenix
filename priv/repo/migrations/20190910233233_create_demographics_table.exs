defmodule Capture.Repo.Migrations.CreateDemographicsTable do
  use Ecto.Migration

  def change do
    create table(:demographics) do
      add :name, :string
      add :value, :string

      timestamps()
    end
  end
end
