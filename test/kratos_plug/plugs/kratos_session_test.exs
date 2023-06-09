defmodule KratosPlug.Plugs.KratosSessionTest do
  alias KratosPlug.Plugs.KratosSession
  import KratosPlug.Defaults
  import KratosPlug.KratosClient.TeslaAdapterMock
  import Map, only: [has_key?: 2, equal?: 2]
  import Plug.Conn
  import Plug.Test
  import Tesla.Mock
  use ExUnit.Case, async: true

  setup do
    mock(mock_kratos())
    :ok
  end

  @kratos_opts client_opts()

  test "no cookie returns conn without session" do
    c =
      :get
      |> conn("/")
      |> KratosSession.call(client_opts())

    refute has_key?(c.assigns, assign_key())
  end

  test "empty cookie returns conn without session" do
    c =
      :get
      |> conn("/")
      |> put_req_header("cookie", "#{cookie_key()}=")
      |> KratosSession.call(client_opts())

    refute has_key?(c.assigns, assign_key())
  end

  test "cookie returns conn with session" do
    c =
      :get
      |> conn("/")
      |> put_req_header("cookie", "#{cookie_key()}=ChocolateChipCookie")
      |> KratosSession.call(client_opts())

    assert has_key?(c.assigns, assign_key())
  end

  test "request without header returns conn without session" do
    c = conn(:get, "/")
    assert equal?(c, KratosSession.call(c, @kratos_opts))
  end

  test "request with token returns conn with session" do
    c =
      :get
      |> conn("/")
      |> put_req_header(header_key(), "privateToken")
      |> KratosSession.call(@kratos_opts)

    refute Map.has_key?(c.assigns, header_key())
  end

  test "init merges default options" do
    assert Keyword.equal?(
             [
               kratos_adapter: KratosPlug.KratosClient.TeslaAdapter,
               proxy_adapter: nil,
               proxy_base_url: "http://localhost:4000",
               tesla_adapter: Tesla.Adapter.Hackney,
               kratos_base_url: "http://kratos",
               foo: :bar
             ],
             KratosSession.init([{:kratos_base_url, "http://kratos"}, {:foo, :bar}])
           )
  end
end
