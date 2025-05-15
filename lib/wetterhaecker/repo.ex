defmodule Wetterhaecker.Repo do
  use Ecto.Repo,
    otp_app: :wetterhaecker,
    adapter: Ecto.Adapters.SQLite3
end
