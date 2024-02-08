defmodule CspDashboardPhxWeb.ViolationReportController do
  use CspDashboardPhxWeb, :controller

  require IEx # TODO: added for debugging purposes, to remove later
  require Logger

  alias CspDashboardPhx.ViolationReports
  alias CspDashboardPhx.ViolationReports.ViolationReport

  def index(conn, params) do
    with {:ok, {violation_reports, meta}} <- ViolationReports.list_violation_reports(params |> Map.put("page_size", 20)) do
      render(conn, :index, meta: meta, violation_reports: violation_reports,
             attributes: ViolationReport.attributes_for_index)
    end
  end

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

  def show(conn, %{"id" => id}) do
    violation_report = ViolationReports.get_violation_report!(id)

    render(conn, :show, violation_report: violation_report,
           report_data: report_data_for_show(violation_report))
  end

  def delete(conn, %{"id" => id}) do
    violation_report = ViolationReports.get_violation_report!(id)
    {:ok, _violation_report} = ViolationReports.delete_violation_report(violation_report)

    conn
    |> put_flash(:info, "Violation report deleted successfully.")
    |> redirect(to: ~p"/violation_reports")
  end

  defp report_data_for_show(%ViolationReport{} = report) do
    report =
      report
      |> Map.take(ViolationReport.attributes_for_show)

    ViolationReport.attributes_for_show
    |> Enum.map(fn
      attr -> {attr, report |> Map.get(attr)}
    end)
    |> Keyword.update(:raw_report, nil, fn
      rr ->
        {:ok, rr} = rr |> Jason.encode()
        rr
    end)
    |> Keyword.filter(fn {_k, v} -> !is_nil(v) end)
  end

  defp extract_report(%Plug.Conn{} = conn) do
    {:ok, body, _conn} = Plug.Conn.read_body(conn)
    {:ok, body} = body |> Jason.decode()

    body
    |> transform()
    |> put_raw_browser(conn)
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

  defp put_raw_report(%{} = report) do
    report
    |> Map.put("raw_report", report)
  end
end
