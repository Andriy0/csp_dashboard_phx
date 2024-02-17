defmodule CspDashboardPhxWeb.ViolationReportsListComponent do
  use CspDashboardPhxWeb, :live_component
  import CspDashboardPhxWeb.Live.Helpers

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
