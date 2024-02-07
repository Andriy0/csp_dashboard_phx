defmodule CspDashboardPhxWeb.ViolationReportController do
  use CspDashboardPhxWeb, :controller

  require IEx
  require Logger

  alias CspDashboardPhx.ViolationReports
  alias CspDashboardPhx.ViolationReports.ViolationReport

  def index(conn, _params) do
    violation_reports = ViolationReports.list_violation_reports()
    render(conn, :index, violation_reports: violation_reports,
           attributes: ViolationReport.attributes_to_display)
  end

  def new(conn, _params) do
    changeset = ViolationReports.change_violation_report(%ViolationReport{})
    render(conn, :new, changeset: changeset,
           attributes: ViolationReport.attributes)
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
           attributes: ViolationReport.attributes_to_display)
  end

  def edit(conn, %{"id" => id}) do
    violation_report = ViolationReports.get_violation_report!(id)
    changeset = ViolationReports.change_violation_report(violation_report)
    render(conn, :edit, violation_report: violation_report, changeset: changeset,
           attributes: ViolationReport.attributes)
  end

  def update(conn, %{"id" => id, "violation_report" => violation_report_params}) do
    violation_report = ViolationReports.get_violation_report!(id)

    case ViolationReports.update_violation_report(violation_report, violation_report_params) do
      {:ok, violation_report} ->
        conn
        |> put_flash(:info, "Violation report updated successfully.")
        |> redirect(to: ~p"/violation_reports/#{violation_report}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, violation_report: violation_report, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    violation_report = ViolationReports.get_violation_report!(id)
    {:ok, _violation_report} = ViolationReports.delete_violation_report(violation_report)

    conn
    |> put_flash(:info, "Violation report deleted successfully.")
    |> redirect(to: ~p"/violation_reports")
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
