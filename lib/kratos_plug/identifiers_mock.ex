defmodule KratosPlug.IdentifiersMock do
  @moduledoc """
  Functions for mocking `KratosPlug.Identifiers`.
  """
  @moduledoc since: "0.1.0"

  alias KratosPlug.Identifiers

  @doc """
  Returns a `KratosPlug.Identifiers` with a cookie in the header.
  """
  @doc since: "0.1.0"
  @spec cookie_identifier() :: Identifiers.t()
  def cookie_identifier(),
    do: %Identifiers{
      headers: [{"cookie", "ory_kratos_session=ChocolateChipCookie"}]
    }

  @doc """
  Returns a `KratosPlug.Identifiers` with a session token in the header.
  """
  @doc since: "0.1.0"
  @spec token_identifier() :: Identifiers.t()
  def token_identifier(),
    do: %Identifiers{
      headers: [{"x-session-token", "privateToken"}]
    }

  @doc """
  Returns a `KratosPlug.Identifiers` with a cookie and session token in the header.
  """
  @doc since: "0.1.0"
  @spec cookie_and_token_identifier() :: Identifiers.t()
  def cookie_and_token_identifier(),
    do: %Identifiers{
      headers: [
        {"cookie", "ory_kratos_session=ChocolateChipCookie"},
        {"x-session-token", "privateToken"}
      ]
    }

  @doc """
  Returns a `KratosPlug.Identifiers` with a bearer token in the header.
  """
  @doc since: "0.1.0"
  @spec bearer_identifier() :: Identifiers.t()
  def bearer_identifier(),
    do: %Identifiers{
      headers: [
        {"authorization", "Bearer privateToken"}
      ]
    }
end
