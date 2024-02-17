defmodule CspDashboardPhx.ViolationReportsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CspDashboardPhx.ViolationReports` context.
  """

  @doc """
  Generate a violation_report.
  """
  def violation_report_fixture(attrs \\ %{}) do
    {:ok, violation_report} =
      attrs
      |> Enum.into(%{
        blocked_uri: "data",
        raw_report: %{
          "blocked_uri" => "data"
        }
      })
      |> CspDashboardPhx.ViolationReports.create_violation_report()

    violation_report
  end
end
