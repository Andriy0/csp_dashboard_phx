defmodule CspDashboardPhxWeb.ViolationReportsLive do
  use CspDashboardPhxWeb, :live_view
  import CspDashboardPhxWeb.Live.Helpers

  alias CspDashboardPhx.ViolationReports
  alias CspDashboardPhx.ViolationReports.ViolationReport

  def mount(_params, _session, socket) do
    default_assigns = %{
      attributes: ViolationReport.attributes_for_index,
      violation_report: nil,
      report_data: nil
    }

    {:ok, assign(socket, default_assigns)}
  end

  def handle_params(params, _session, socket) do
    case ViolationReports.list_violation_reports(params) do
      {:ok, {violation_reports, meta}} ->
        new_assigns = %{
          violation_reports: violation_reports,
          meta: meta
        }

        {:noreply, assign(socket, new_assigns)}

      {:error, _meta} ->
        {:noreply, push_navigate(socket, to: ~p"/reports_live")}
    end
  end

  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")

    {:noreply, push_patch(socket, to: ~p"/reports_live?#{params}")}
  end

  def handle_event("reset-filter", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/reports_live")}
  end

  def handle_event("delete-report", %{"report_id" => id}, socket) do
    violation_report = ViolationReports.get_violation_report!(id)

    with {:ok, _violation_report} = ViolationReports.delete_violation_report(violation_report) do
      violation_reports =
        socket.assigns.violation_reports
        |> Enum.reject(&(&1.id == id))

      {:noreply, assign(socket, violation_reports: violation_reports)}
    end
  end

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
