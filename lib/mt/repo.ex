defmodule Mt.Repo do
  use Ecto.Repo,
    otp_app: :mt,
    adapter: Ecto.Adapters.Postgres
end
