defmodule KratosPlugTest do
  import KratosPlug.Defaults
  use ExUnit.Case, async: true
  use Plug.Test

  test "session_active?/1 missing session" do
    conn = conn(:get, "/")
    refute KratosPlug.session_active?(conn)
  end

  test "session_active?/1 inactive session" do
    conn = conn(:get, "/")
    conn = assign(conn, assign_key(), %{"active" => false})
    refute KratosPlug.session_active?(conn)
  end

  test "session_active?/1 active session" do
    conn = conn(:get, "/")
    conn = assign(conn, assign_key(), %{"active" => true})
    assert KratosPlug.session_active?(conn)
  end

  test "session_valid?/1 missing session" do
    conn = conn(:get, "/")
    refute KratosPlug.session_valid?(conn)
  end

  test "session_valid?/1 inactive session" do
    conn = conn(:get, "/")
    conn = assign(conn, assign_key(), %{"active" => false})
    refute KratosPlug.session_valid?(conn)
  end

  test "session_valid?/1 active session" do
    conn = conn(:get, "/")
    conn = assign(conn, assign_key(), %{"active" => true})
    assert KratosPlug.session_valid?(conn)
  end

  test "aal0?/1" do
    conn = conn(:get, "/")
    conn = assign(conn, assign_key(), %{authenticator_assurance_level: "aal0"})
    assert KratosPlug.aal0?(conn)
  end

  test "aal1?/1" do
    conn = conn(:get, "/")
    conn = assign(conn, assign_key(), %{authenticator_assurance_level: "aal1"})
    assert KratosPlug.aal1?(conn)
  end

  test "aal2?/1" do
    conn = conn(:get, "/")
    conn = assign(conn, assign_key(), %{authenticator_assurance_level: "aal2"})
    assert KratosPlug.aal2?(conn)
  end

  test "aal3?/1" do
    conn = conn(:get, "/")
    conn = assign(conn, assign_key(), %{authenticator_assurance_level: "aal3"})
    assert KratosPlug.aal3?(conn)
  end
end
