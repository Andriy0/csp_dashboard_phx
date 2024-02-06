defmodule CspDashboardPhxWeb.ViolationReportController do
  use CspDashboardPhxWeb, :controller

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

  def create(conn, %{"violation_report" => violation_report_params}) do
    case ViolationReports.create_violation_report(violation_report_params) do
      {:ok, violation_report} ->
        conn
        |> put_flash(:info, "Violation report created successfully.")
        |> redirect(to: ~p"/violation_reports/#{violation_report}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
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
end
