defmodule CspDashboardPhxWeb.ViolationReportsListComponent do
  use CspDashboardPhxWeb, :live_component
  import CspDashboardPhxWeb.Live.Helpers

  alias CspDashboardPhx.ViolationReports

  def handle_event("delete-report", %{"report_id" => id}, socket) do
    violation_report = ViolationReports.get_violation_report!(id)

    with {:ok, _violation_report} = ViolationReports.delete_violation_report(violation_report) do
      violation_reports =
        socket.assigns.violation_reports
        |> Enum.reject(&(&1.id == id))

      {:noreply, assign(socket, violation_reports: violation_reports)}
    end
  end

  defp open_show_report_modal(report_id) do
    %JS{}
    |> JS.push("open-show-report-modal", value: %{report_id: report_id})
    |> show_modal("show-report-modal")
  end

  defp delete_report(report_id) do
    %JS{}
    |> JS.push("delete-report", value: %{report_id: report_id})
  end
end
