defmodule CspDashboardPhx.ViolationReports do
  @moduledoc """
  The ViolationReports context.
  """

  import Ecto.Query, warn: false
  alias CspDashboardPhx.Repo

  alias CspDashboardPhx.ViolationReports.ViolationReport

  @doc """
  Returns the list of violation_reports.

  ## Examples

      iex> list_violation_reports()
      [%ViolationReport{}, ...]

  """
  def list_violation_reports do
    Repo.all(ViolationReport)
  end

  @doc """
  Gets a single violation_report.

  Raises `Ecto.NoResultsError` if the Violation report does not exist.

  ## Examples

      iex> get_violation_report!(123)
      %ViolationReport{}

      iex> get_violation_report!(456)
      ** (Ecto.NoResultsError)

  """
  def get_violation_report!(id), do: Repo.get!(ViolationReport, id)

  @doc """
  Creates a violation_report.

  ## Examples

      iex> create_violation_report(%{field: value})
      {:ok, %ViolationReport{}}

      iex> create_violation_report(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_violation_report(attrs \\ %{}) do
    %ViolationReport{}
    |> ViolationReport.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a violation_report.

  ## Examples

      iex> update_violation_report(violation_report, %{field: new_value})
      {:ok, %ViolationReport{}}

      iex> update_violation_report(violation_report, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_violation_report(%ViolationReport{} = violation_report, attrs) do
    violation_report
    |> ViolationReport.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a violation_report.

  ## Examples

      iex> delete_violation_report(violation_report)
      {:ok, %ViolationReport{}}

      iex> delete_violation_report(violation_report)
      {:error, %Ecto.Changeset{}}

  """
  def delete_violation_report(%ViolationReport{} = violation_report) do
    Repo.delete(violation_report)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking violation_report changes.

  ## Examples

      iex> change_violation_report(violation_report)
      %Ecto.Changeset{data: %ViolationReport{}}

  """
  def change_violation_report(%ViolationReport{} = violation_report, attrs \\ %{}) do
    ViolationReport.changeset(violation_report, attrs)
  end
end
