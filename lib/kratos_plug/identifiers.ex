defmodule KratosPlug.Identifiers do
  @moduledoc """
  Types and functions for session identifiers.
  Identifiers are the client secret that may be given to kratos in return for a session.
  """
  @moduledoc since: "0.1.0"
  import KratosPlug.Defaults

  @type headers :: Plug.Conn.headers()
  @type jwt :: String.t() | map()
  @type t :: %__MODULE__{
          headers: headers() | nil,
          jwt: jwt() | nil
        }

  defstruct [:headers, :jwt]

  @doc """
  Returns a KratosPlug.Identifiers struct populated with `conn` Plug.Conn.
  """
  @doc since: "0.1.0"
  @spec get_identifiers(Plug.Conn.t()) :: Plug.Identifiers.t()
  def get_identifiers(conn) do
    %__MODULE__{
      headers: get_session_headers(conn),
    }
  end

  @doc """
  Returns headers from `conn` that kratos checks
  for session identifiers.
  """
  @doc since: "0.1.0"
  @spec get_session_headers(Plug.Conn.t()) :: Plug.Conn.headers()
  def get_session_headers(conn) do
    for {key, value} <- conn.req_headers,
        Enum.member?(header_keys(), key) do
      {key, value}
    end
  end
end
