defmodule CspDashboardPhxWeb.ViolationReportController do
  use CspDashboardPhxWeb, :controller

  require Logger

  alias CspDashboardPhx.ViolationReports

  def create(conn, _params) do
    case ViolationReports.create_violation_report(extract_report(conn)) do
      {:ok, _violation_report} ->
        message = "Record was successfully inserted into a database."
        Logger.debug(message)

        conn
        |> json(%{status: :ok, message: message})

      {:error, %Ecto.Changeset{} = changeset} ->
        message = inspect(changeset |> Map.get(:errors))
        Logger.warning("Failed to insert record into a database: " <> message)

        conn
        |> put_status(400)
        |> json(%{status: :error, message: message})
    end
  end

  defp extract_report(%Plug.Conn{} = conn) do
    {:ok, body, _conn} = Plug.Conn.read_body(conn)
    {:ok, body} = body |> Jason.decode()

    body
    |> transform()
    |> put_raw_browser(conn)
    |> put_incoming_ip(conn)
    |> put_raw_report()
  end

  defp transform(%{"csp-report" => report}) do
    report
    |> Map.new(fn
      {key, value} -> {key |> String.replace("-", "_"), value}
    end)
  end

  defp put_raw_browser(%{} = report, %Plug.Conn{} = conn) do
    {:ok, raw_browser} =
      get_req_header(conn, "user-agent")
      |> Enum.fetch(0)

    report
    |> Map.put("raw_browser", raw_browser)
  end

  defp put_incoming_ip(%{} = report, %Plug.Conn{} = conn) do
    incoming_ip =
      conn.remote_ip
      |> :inet.ntoa() |> to_string()

    report
    |> Map.put("incoming_ip", incoming_ip)
  end

  defp put_raw_report(%{} = report) do
    report
    |> Map.put("raw_report", report)
  end
end
