defmodule CspDashboardPhx.ViolationReportsTest do
  use CspDashboardPhx.DataCase

  alias CspDashboardPhx.ViolationReports

  describe "violation_reports" do
    alias CspDashboardPhx.ViolationReports.ViolationReport

    import CspDashboardPhx.ViolationReportsFixtures

    @invalid_attrs %{blocked_uri: nil}

    test "list_violation_reports/0 returns all violation_reports" do
      violation_report = violation_report_fixture()
      assert ViolationReports.list_violation_reports() == [violation_report]
    end

    test "get_violation_report!/1 returns the violation_report with given id" do
      violation_report = violation_report_fixture()
      assert ViolationReports.get_violation_report!(violation_report.id) == violation_report
    end

    test "create_violation_report/1 with valid data creates a violation_report" do
      valid_attrs = %{blocked_uri: "some blocked_uri"}

      assert {:ok, %ViolationReport{} = violation_report} = ViolationReports.create_violation_report(valid_attrs)
      assert violation_report.blocked_uri == "some blocked_uri"
    end

    test "create_violation_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ViolationReports.create_violation_report(@invalid_attrs)
    end

    test "update_violation_report/2 with valid data updates the violation_report" do
      violation_report = violation_report_fixture()
      update_attrs = %{blocked_uri: "some updated blocked_uri"}

      assert {:ok, %ViolationReport{} = violation_report} = ViolationReports.update_violation_report(violation_report, update_attrs)
      assert violation_report.blocked_uri == "some updated blocked_uri"
    end

    test "update_violation_report/2 with invalid data returns error changeset" do
      violation_report = violation_report_fixture()
      assert {:error, %Ecto.Changeset{}} = ViolationReports.update_violation_report(violation_report, @invalid_attrs)
      assert violation_report == ViolationReports.get_violation_report!(violation_report.id)
    end

    test "delete_violation_report/1 deletes the violation_report" do
      violation_report = violation_report_fixture()
      assert {:ok, %ViolationReport{}} = ViolationReports.delete_violation_report(violation_report)
      assert_raise Ecto.NoResultsError, fn -> ViolationReports.get_violation_report!(violation_report.id) end
    end

    test "change_violation_report/1 returns a violation_report changeset" do
      violation_report = violation_report_fixture()
      assert %Ecto.Changeset{} = ViolationReports.change_violation_report(violation_report)
    end
  end
end
