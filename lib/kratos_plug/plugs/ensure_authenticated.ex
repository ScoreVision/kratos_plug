defmodule KratosPlug.Plugs.EnsureAuthenticated do
  @moduledoc """
  A module plug that ensures a valid Kratos session is present on the conn.
  If one is not present, the pipeline will halt and an error code added.
  """
  @moduledoc since: "0.1.0"
  @behaviour Plug

  import KratosPlug, only: [session_valid?: 1]
  import KratosPlug.Config
  require Logger

  @impl Plug
  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts) do
    Logger.debug("Initializing EnsureAuthenticated plug")
    Logger.debug("Plug options: #{inspect(opts)}")
    opts
    |> eval_opts()
    |> merge_defaults()
  end

  @impl Plug
  @spec call(Plug.Conn.t(), Plug.opts()) :: Plug.Conn.t()
  def call(conn, _opts) do
    Logger.debug("Calling EnsureAuthenticated plug")
    case session_valid?(conn) do
      true ->
        Logger.debug("Session authenticated")
        conn

      false ->
        Logger.debug("Session not authenticated")
        conn
        |> Plug.Conn.put_status(401)
        |> Plug.Conn.halt()
    end
  end
end
