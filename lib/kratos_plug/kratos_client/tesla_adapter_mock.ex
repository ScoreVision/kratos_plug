defmodule KratosPlug.KratosClient.TeslaAdapterMock do
  @moduledoc """
  Collection of functions for mocking `KratosPlug.KratosClient.TeslaAdapter`.
  """
  @moduledoc since: "0.1.0"

  import Tesla.Mock

  @doc """
  Returns the client options for the tesla adapter under mock.
  """
  @spec client_opts() :: Keyword.t()
  def client_opts() do
    [
      {:tesla_adapter, Tesla.Mock},
      {:kratos_adapter, KratosPlug.KratosClient.TeslaAdapter},
      {:kratos_base_url, "http://kratos"}
    ]
  end

  @doc """
  Returns a function that can be used to mock the kratos server.

  Works with Tesla.Mock.mock/1

  ## Request shapes
    - Only have a cookie
    - Only have a token
    - Have both a cookie and a token
    - Have neither a cookie nor a token
  """
  @spec mock_kratos() :: fun()
  def mock_kratos() do
    fn
      # expected request shape to kratos when we only have a cookie.
      %{
        method: :get,
        url: "http://kratos/sessions/whoami",
        headers: [{"cookie", "ory_kratos_session=ChocolateChipCookie"}, {"x-session-token", nil}]
      } ->
        success_resp()

      # expected request shape to kratos when we only have a token and empty cookie.
      %{
        method: :get,
        url: "http://kratos/sessions/whoami",
        headers: [{"cookie", "ory_kratos_session="}, {"x-session-token", "privateToken"}]
      } ->
        success_resp()

      # expected request shape to kratos when we only have a token.
      %{
        method: :get,
        url: "http://kratos/sessions/whoami",
        headers: [{"x-session-token", "privateToken"}]
      } ->
        success_resp()

      # expected request shape to kratos when we only have a cookie.
      %{
        method: :get,
        url: "http://kratos/sessions/whoami",
        headers: [{"cookie", "ory_kratos_session=ChocolateChipCookie"}]
      } ->
        success_resp()

      # expected request shape to kratos when we have both a cookie and a token.
      %{
        method: :get,
        url: "http://kratos/sessions/whoami",
        headers: [
          {"cookie", "ory_kratos_session=ChocolateChipCookie"},
          {"x-session-token", "privateToken"}
        ]
      } ->
        success_resp()

      # expected request shape to kratos when we have neither a cookie nor a token.
      %{
        method: :get,
        url: "http://kratos/sessions/whoami",
        headers: [
          {"cookie", "ory_kratos_session="},
          {"x-session-token", nil}
        ]
      } ->
        error_resp()

      # expected request shape to kratos when we have neither a cookie nor a token.
      %{
        method: :get,
        url: "http://kratos/sessions/whoami",
        headers: nil
      } ->
        error_resp()

      # expected request shape to kratos when we have neither a cookie nor a token.
      %{
        method: :get,
        url: "http://kratos/sessions/whoami",
        headers: [
          {"cookie", "ory_kratos_session="},
          {"x-session-token", ""}
        ]
      } ->
        error_resp()

      # expected request shape to kratos when we have an empty cookie.
      %{
        method: :get,
        url: "http://kratos/sessions/whoami",
        headers: [
          {"cookie", "ory_kratos_session="}
        ]
      } ->
        error_resp()

      # expected request shape to kratos when we have an empty header token.
      %{
        method: :get,
        url: "http://kratos/sessions/whoami",
        headers: [
          {"x-session-token", ""}
        ]
      } ->
        error_resp()

      # expected request shape to kratos when we have no headers.
      %{
        method: :get,
        url: "http://kratos/sessions/whoami",
        headers: []
      } ->
        error_resp()
    end
  end

  defp error_resp(),
    do:
      json(
        %{
          error: %{
            code: 401,
            status: 401,
            request: "7c6eb3ff-a5a5-9584-b375-c466104a95d2",
            reason: "No valid session credentials found in the request.",
            message: "The request could not be authorized"
          }
        },
        status: 401
      )

  defp success_resp(), do: json(%{"active" => true}, status: 200)
end
