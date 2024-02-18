defmodule CspDashboardPhxWeb.ViolationReportsLive do
  use CspDashboardPhxWeb, :live_view
  import CspDashboardPhxWeb.Live.Helpers

  alias CspDashboardPhx.ViolationReports
  alias CspDashboardPhx.ViolationReports.ViolationReport

  @impl true
  def mount(_params, _session, socket) do
    default_assigns = %{
      attributes: ViolationReport.attributes_for_index(),
      violation_report: nil,
      report_data: nil
    }

    {:ok, assign(socket, default_assigns)}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _session, socket) do
    case ViolationReports.list_violation_reports(params) do
      {:ok, {violation_reports, meta}} ->
        new_assigns = %{
          violation_reports: violation_reports,
          meta: meta
        }

        {:noreply, assign(socket, new_assigns)}

      {:error, _meta} ->
        {:noreply, push_navigate(socket, to: ~p"/violation_reports")}
    end
  end

  @impl true
  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")

    {:noreply, push_patch(socket, to: ~p"/violation_reports?#{params}")}
  end

  def handle_event("reset-filter", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/violation_reports")}
  end
end
