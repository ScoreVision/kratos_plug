defmodule KratosPlug.KratosClient.TeslaAdapter do
  @moduledoc """
  A tesla-hackney adapter for the `KratosPlug.KratosClient` behaviour.
  """
  @moduledoc since: "0.1.0"
  @behaviour KratosPlug.KratosClient
  @who_am_i_path "/sessions/whoami"

  alias KratosPlug.Config.Options
  alias KratosPlug.Identifiers
  require Logger

  @impl KratosPlug.KratosClient
  @spec who_am_i(Identifiers.t(), Options.t()) ::
          {:ok, map()} | {:error, binary()} | {:error, map()}
  def who_am_i(identifiers, opts) do
    tesla_client = client(opts)

    req_opts = [
      headers: identifiers.headers || []
    ]

    case Tesla.get(tesla_client, @who_am_i_path, req_opts) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        Logger.debug("Session found")
        {:ok, body}

      {:ok, %Tesla.Env{status: 401, body: body}} ->
        Logger.debug("no session found")
        {:error, body}

      {:error, reason} ->
        Logger.debug("Error fetching session: #{inspect(reason)}")
        {:error, reason}
    end
  end

  @doc """
  Builds a Tesla client with the given KratosPlug.Config.Options.
  """
  @spec client(Options.t()) :: Tesla.Client.t()
  def client(opts) do
    base_url = Keyword.get(opts, :kratos_base_url)
    adapter = Keyword.get(opts, :tesla_adapter)

    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware, adapter)
  end
end
