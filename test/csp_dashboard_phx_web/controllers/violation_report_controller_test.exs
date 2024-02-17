defmodule CspDashboardPhxWeb.ViolationReportControllerTest do
  use CspDashboardPhxWeb.ConnCase

  describe "index" do
    test "lists all violation_reports", %{conn: conn} do
      conn = get(conn, ~p"/violation_reports")
      assert html_response(conn, 200) =~ "Listing Violation reports"
    end
  end
end
