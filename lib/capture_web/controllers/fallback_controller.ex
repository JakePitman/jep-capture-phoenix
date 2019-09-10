defmodule CaptureWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` Capture.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CaptureWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(CaptureWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(CaptureWeb.ErrorView)
    |> render(:"404")
  end
end
