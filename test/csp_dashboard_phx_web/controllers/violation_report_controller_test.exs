defmodule CspDashboardPhxWeb.ViolationReportControllerTest do
  use CspDashboardPhxWeb.ConnCase

  import CspDashboardPhx.ViolationReportsFixtures

  @create_attrs %{blocked_uri: "some blocked_uri"}
  @update_attrs %{blocked_uri: "some updated blocked_uri"}
  @invalid_attrs %{blocked_uri: nil}

  describe "index" do
    test "lists all violation_reports", %{conn: conn} do
      conn = get(conn, ~p"/violation_reports")
      assert html_response(conn, 200) =~ "Listing Violation reports"
    end
  end

  describe "new violation_report" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/violation_reports/new")
      assert html_response(conn, 200) =~ "New Violation report"
    end
  end

  describe "create violation_report" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/violation_reports", violation_report: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/violation_reports/#{id}"

      conn = get(conn, ~p"/violation_reports/#{id}")
      assert html_response(conn, 200) =~ "Violation report #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/violation_reports", violation_report: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Violation report"
    end
  end

  describe "edit violation_report" do
    setup [:create_violation_report]

    test "renders form for editing chosen violation_report", %{conn: conn, violation_report: violation_report} do
      conn = get(conn, ~p"/violation_reports/#{violation_report}/edit")
      assert html_response(conn, 200) =~ "Edit Violation report"
    end
  end

  describe "update violation_report" do
    setup [:create_violation_report]

    test "redirects when data is valid", %{conn: conn, violation_report: violation_report} do
      conn = put(conn, ~p"/violation_reports/#{violation_report}", violation_report: @update_attrs)
      assert redirected_to(conn) == ~p"/violation_reports/#{violation_report}"

      conn = get(conn, ~p"/violation_reports/#{violation_report}")
      assert html_response(conn, 200) =~ "some updated blocked_uri"
    end

    test "renders errors when data is invalid", %{conn: conn, violation_report: violation_report} do
      conn = put(conn, ~p"/violation_reports/#{violation_report}", violation_report: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Violation report"
    end
  end

  describe "delete violation_report" do
    setup [:create_violation_report]

    test "deletes chosen violation_report", %{conn: conn, violation_report: violation_report} do
      conn = delete(conn, ~p"/violation_reports/#{violation_report}")
      assert redirected_to(conn) == ~p"/violation_reports"

      assert_error_sent 404, fn ->
        get(conn, ~p"/violation_reports/#{violation_report}")
      end
    end
  end

  defp create_violation_report(_) do
    violation_report = violation_report_fixture()
    %{violation_report: violation_report}
  end
end
