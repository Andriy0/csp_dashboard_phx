defmodule CspDashboardPhx.Repo.Migrations.CreateViolationReports do
  use Ecto.Migration

  def change do
    create table(:violation_reports) do
      add :blocked_uri, :text
      add :disposition, :string
      add :document_uri, :text
      add :effective_directive, :string
      add :violated_directive, :string
      add :original_policy, :text
      add :referrer, :string
      add :status_code, :integer
      add :raw_report, :jsonb
      add :raw_browser, :string
      add :source_file, :string
      add :script_sample, :string
      add :line_number, :integer
      add :incoming_ip, :string

      timestamps(type: :utc_datetime)
    end
  end
end
