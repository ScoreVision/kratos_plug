defmodule KratosPlug.KratosClient.TeslaAdapterTest do
  alias KratosPlug.Identifiers
  alias KratosPlug.KratosClient.TeslaAdapter
  import KratosPlug.IdentifiersMock
  import KratosPlug.KratosClient.TeslaAdapterMock
  use ExUnit.Case, async: true

  setup do
    Tesla.Mock.mock(mock_kratos())
    :ok
  end

  test "who_am_i without identifier" do
    i = %Identifiers{}

    assert match?(
             {:error, _},
             TeslaAdapter.who_am_i(i, client_opts())
           )
  end

  test "who_am_i with tesla error" do
    # no opts are passed
    # hackney will error on protocol
    i = %Identifiers{}

    assert match?(
             {:error, {:bad_scheme, 'foobar'}},
             TeslaAdapter.who_am_i(i, [
               {:kratos_base_url, "foobar://kratos"}
             ])
           )
  end

  test "who_am_i with cookie" do
    assert match?(
             {:ok, %{"active" => true}},
             TeslaAdapter.who_am_i(cookie_identifier(), client_opts())
           )
  end

  test "who_am_i with header token" do
    assert match?(
             {:ok, %{"active" => true}},
             TeslaAdapter.who_am_i(token_identifier(), client_opts())
           )
  end

  test "who_am_i with token and cookie" do
    assert match?(
             {:ok, %{"active" => true}},
             TeslaAdapter.who_am_i(cookie_and_token_identifier(), client_opts())
           )
  end

  test "tesla client with options" do
    assert match?(
             %Tesla.Client{
               fun: nil,
               pre: [
                 {Tesla.Middleware.BaseUrl, :call, ["http://kratos"]},
                 {Tesla.Middleware.JSON, :call, [[]]}
               ],
               post: [],
               adapter: {Tesla.Mock, :call, [[]]}
             },
             TeslaAdapter.client(client_opts())
           )
  end

  test "tesla client without options" do
    assert match?(
             %Tesla.Client{
               fun: nil,
               pre: [
                 {Tesla.Middleware.BaseUrl, :call, [nil]},
                 {Tesla.Middleware.JSON, :call, [[]]}
               ],
               post: [],
               adapter: nil
             },
             TeslaAdapter.client([])
           )
  end
end
