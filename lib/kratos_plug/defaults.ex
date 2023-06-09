defmodule KratosPlug.Defaults do
  @moduledoc """
  A collection of functions that return default values.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Key used to store a session in Plug.Conn.assigns.
  """
  @doc since: "0.1.0"
  @spec assign_key() :: atom()
  def assign_key(), do: :kratos_session

  @doc """
  Key used to store a session in an HTTP cookie. Kratos may
  be configured to use any cookie name.
  """
  @doc since: "0.1.0"
  @spec cookie_key() :: String.t()
  def cookie_key(), do: "ory_kratos_session"

  @doc """
  Key used to store a session in an HTTP header.
  """
  @doc since: "0.1.0"
  @spec header_key() :: String.t()
  def header_key(), do: "x-session-token"

  @doc """
  Headers a client may use to send a session identifier.
  """
  @spec header_keys() :: [binary()]
  def header_keys(), do: ["x-session-token", "authorization", "cookie"]
end
