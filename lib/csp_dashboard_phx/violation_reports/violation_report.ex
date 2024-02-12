defmodule CspDashboardPhx.ViolationReports.ViolationReport do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:report],
    sortable: [
      :blocked_uri,
      :document_uri,
      :violated_directive,
      :referrer,
      :incoming_ip,
      :inserted_at
    ],
    adapter_opts: [
      compound_fields: [report: [
        :blocked_uri,
        :document_uri,
        :violated_directive,
        :referrer
      ]]
    ],
    default_limit: 15,
    max_limit: 50
  }

  schema "violation_reports" do
    field :blocked_uri, :string
    field :disposition, :string
    field :document_uri, :string
    field :effective_directive, :string
    field :violated_directive, :string
    field :original_policy, :string
    field :referrer, :string
    field :status_code, :integer
    field :raw_report, :map
    field :raw_browser, :string
    field :source_file, :string
    field :script_sample, :string
    field :line_number, :integer
    field :incoming_ip, :string

    timestamps(type: :utc_datetime)
  end

  def attributes do
    [
      :blocked_uri,
      :disposition,
      :document_uri,
      :effective_directive,
      :violated_directive,
      :original_policy,
      :referrer,
      :status_code,
      :raw_report,
      :raw_browser,
      :source_file,
      :script_sample,
      :line_number,
      :incoming_ip
    ]
  end

  def attributes_for_index do
    [
      :blocked_uri,
      :document_uri,
      :violated_directive,
      :referrer,
      :incoming_ip,
      :inserted_at
    ]
  end

  def attributes_for_show do
    [
      :blocked_uri,
      :disposition,
      :document_uri,
      :effective_directive,
      :violated_directive,
      :original_policy,
      :referrer,
      :status_code,
      :raw_browser,
      :source_file,
      :script_sample,
      :line_number,
      :incoming_ip,
      :inserted_at
    ]
  end

  @doc false
  def changeset(violation_report, attrs) do
    violation_report
    |> cast(attrs, attributes())
    |> validate_required([:blocked_uri, :raw_report])
  end
end
