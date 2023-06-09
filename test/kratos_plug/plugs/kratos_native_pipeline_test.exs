defmodule KratosPlug.Plugs.KratosNativePipelineTest do
  alias KratosPlug.Plugs.KratosNativePipeline
  import KratosPlug.Defaults
  import KratosPlug.KratosClient.TeslaAdapterMock
  import Plug.Conn, only: [put_req_header: 3]
  import Plug.Test
  import Tesla.Mock
  use ExUnit.Case, async: true

  setup do
    mock(mock_kratos())
    :ok
  end

  test "header authenticated flow" do
    c =
      :get
      |> conn("/")
      |> put_req_header(header_key(), "privateToken")
      |> KratosNativePipeline.call(client_opts())

    assert match?(%Plug.Conn{assigns: %{kratos_session: %{"active" => true}}}, c)
  end

  test "header unauthenticated flow" do
    c =
      :get
      |> conn("/")
      |> put_req_header(header_key(), "")
      |> KratosNativePipeline.call(client_opts())

    assert c.halted
  end

  test "cookie authenticated flow" do
    c =
      :get
      |> conn("/")
      |> put_req_header("cookie", "#{cookie_key()}=ChocolateChipCookie")
      |> KratosNativePipeline.call(client_opts())

    assert match?(
             %Plug.Conn{assigns: %{kratos_session: %{"active" => true}}},
             c
           )
  end

  test "cookie unauthenticated flow" do
    c =
      :get
      |> conn("/")
      |> put_req_header("cookie", "#{cookie_key()}=")
      |> KratosNativePipeline.call(client_opts())

    assert c.halted
  end

  test "basic unauthenticated flow" do
    c =
      :get
      |> conn("/")
      |> KratosNativePipeline.call(client_opts())

    assert c.halted
  end

  test "init leaves opts unaltered" do
    assert Keyword.equal?([], KratosNativePipeline.init([]))
  end
end
