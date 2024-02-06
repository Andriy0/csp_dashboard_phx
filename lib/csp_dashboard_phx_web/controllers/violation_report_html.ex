defmodule CspDashboardPhxWeb.ViolationReportHTML do
  use CspDashboardPhxWeb, :html

  embed_templates "violation_report_html/*"

  @doc """
  Renders a violation_report form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def violation_report_form(assigns)
end
