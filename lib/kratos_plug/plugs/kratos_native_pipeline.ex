defmodule KratosPlug.Plugs.KratosNativePipeline do
  @moduledoc """
  This pipeline is used to authenticate incoming requests using the kratos native flow.
  Options given to this pipeline will be passed unaltered to each of
  the plugs within it. Adding this pipeline to your router
  is the the prefered way to use KratosPlug.

  ## Plugs in this pipeline

  - `KratosPlug.Plugs.KratosSession`
  - `KratosPlug.Plugs.EnsureAuthenticated`

  This pipeline will halt if it cannot verify the incoming Kratos identity.

  ## Configuration

  See `KratosPlug.Config` for configuration options.
  """
  @moduledoc since: "0.1.0"
  @behaviour Plug

  import Plug, only: [run: 2]
  require Logger

  @impl Plug
  @spec init(Keyword.t()) :: Keyword.t()
  def init(opts) do
    opts
  end

  @impl Plug
  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(conn, opts) do
    Logger.debug("Calling KratosNativePipeline plug")
    run(
      conn,
      [
        {KratosPlug.Plugs.KratosSession, opts},
        {KratosPlug.Plugs.EnsureAuthenticated, opts}
      ]
    )
  end
end
