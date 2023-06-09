defmodule KratosPlug.Plugs.KratosSession do
  @moduledoc """
  Plug extracts all session identifiers from the conn request and attempts to fetch a session from kratos. When a session is found, it is assigned to the conn.

  No authorization is checked, and a lack of session will not halt this plug.
  """
  @moduledoc since: "0.1.0"
  @behaviour Plug

  import KratosPlug
  import KratosPlug.Config
  import KratosPlug.Identifiers
  require Logger

  @impl Plug
  @spec init(Keyword.t()) :: Keyword.t()
  def init(opts) do
    Logger.debug("Initializing KratosPlug.Plugs.KratosSession")
    Logger.debug("opts: #{inspect(opts)}")

    opts
    |> eval_opts()
    |> merge_defaults()
  end

  @impl Plug
  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(conn, opts) do
    adapter = Keyword.get(opts, :kratos_adapter)

    conn
    |> get_identifiers()
    |> adapter.who_am_i(opts)
    |> case do
      {:ok, session} ->
        Logger.debug("Successfully retrieved session from Kratos")
        assign_session(conn, session)

      {:error, error} ->
        Logger.debug("Failed to retrieve session from Kratos: #{inspect(error)}")
        conn
    end
  end
end
