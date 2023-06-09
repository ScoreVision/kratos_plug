defmodule KratosPlug.Plugs.EnsureAuthenticatedTest do
  alias Keyword
  alias KratosPlug.Plugs.EnsureAuthenticated
  import KratosPlug.Defaults
  import Plug.Conn, only: [assign: 3]
  import Plug.Test, only: [conn: 2]
  use ExUnit.Case, async: true

  test "returns 401 when no session key is present" do
    conn = conn(:get, "/")
    conn = EnsureAuthenticated.call(conn, [])
    assert conn.status == 401
  end

  test "halts plug chain when no session key is present" do
    conn = conn(:get, "/")
    conn = EnsureAuthenticated.call(conn, [])
    assert conn.halted
  end

  test "halts plug chain when session is present but invalid" do
    conn = conn(:get, "/")
    conn = assign(conn, assign_key(), %{})
    conn = EnsureAuthenticated.call(conn, [])
    assert conn.halted
  end

  test "leaves status unchanged when session present and valid" do
    conn = conn(:get, "/")
    conn = assign(conn, assign_key(), %{"active" => true})
    conn = EnsureAuthenticated.call(conn, [])
    assert conn.status == nil
  end

  test "does not halt when session present and valid" do
    conn = conn(:get, "/")
    conn = assign(conn, assign_key(), %{"active" => true})
    conn = EnsureAuthenticated.call(conn, [])
    refute conn.halted
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
             EnsureAuthenticated.init([{:kratos_base_url, "http://kratos"}, {:foo, :bar}])
           )
  end
end
