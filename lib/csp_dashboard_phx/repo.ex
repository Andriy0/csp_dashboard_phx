defmodule CspDashboardPhx.Repo do
  use Ecto.Repo,
    otp_app: :csp_dashboard_phx,
    adapter: Ecto.Adapters.Postgres
end
