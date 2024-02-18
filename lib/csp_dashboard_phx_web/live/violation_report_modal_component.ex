defmodule CspDashboardPhxWeb.ViolationReportModalComponent do
  use CspDashboardPhxWeb, :live_component

  alias CspDashboardPhx.ViolationReports.ViolationReport

  def handle_event("open-show-report-modal", %{"report_id" => id}, socket) do
    violation_report =
      socket.assigns.violation_reports
      |> Enum.find(&(&1.id == id))

    new_assigns = %{
      violation_report: violation_report,
      report_data: report_data_for_show(violation_report)
    }

    {:noreply, assign(socket, new_assigns)}
  end

  defp report_data_for_show(%ViolationReport{} = report) do
    report =
      report
      |> Map.take(ViolationReport.attributes_for_show())

    ViolationReport.attributes_for_show()
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
end
