defmodule KratosPlug do
  @moduledoc """
  Functions for working with kratos sessions. This functionality expects that a kratos session has been previously fetched and stored in `Plug.Conn.assigns`.
  """
  @moduledoc since: "0.1.0"

  import KratosPlug.Defaults
  import Plug.Conn, only: [assign: 3]
  require Logger

  @doc """
  Returns a `conn` Plug.Conn with a kratos `session` attached.
  """
  @doc since: "0.1.0"
  @spec assign_session(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def assign_session(conn, session) do
    Logger.debug("Assigning session to conn: #{inspect(session)}")
    assign(conn, assign_key(), session)
  end

  @doc """
  Returns the kratos session as a map.
  """
  @doc since: "0.2.0"
  @spec get_session(Plug.Conn.t()) :: map()
  def get_session(conn) do
    Map.get(conn.assigns, assign_key(), %{})
  end

  @doc """
  Returns true when the conn has an active Kratos session.
  """
  @doc since: "0.1.0"
  @spec session_active?(Plug.Conn.t()) :: boolean()
  def session_active?(conn) do
    session = conn.assigns[assign_key()]

    match?(
      %{"active" => true},
      session
    )
  end

  @doc """
  Returns true when the conn has a valid Kratos session.

  At some point we may wish to add additional checks to this function.
  Those future changes will set it apart from `KratosPlug.Plug.Api.session_active?/1`.
  """
  @doc since: "0.1.0"
  @spec session_valid?(Plug.Conn.t()) :: boolean()
  def session_valid?(conn), do: session_active?(conn)

  @doc """
  Returns true when the sessions authenticator assurance level is 0.
  """
  @doc since: "0.1.0"
  @spec aal0?(Plug.Conn.t()) :: boolean()
  def aal0?(conn) do
    aal?(conn, 0)
  end

  @doc """
  Returns true when the sessions authenticator assurance level is 1.
  """
  @doc since: "0.1.0"
  @spec aal1?(Plug.Conn.t()) :: boolean()
  def aal1?(conn) do
    aal?(conn, 1)
  end

  @doc """
  Returns true when the sessions authenticator assurance level is 2.
  """
  @doc since: "0.1.0"
  @spec aal2?(Plug.Conn.t()) :: boolean()
  def aal2?(conn) do
    aal?(conn, 2)
  end

  @doc """
  Returns true when the sessions authenticator assurance level is 3.
  """
  @doc since: "0.1.0"
  @spec aal3?(Plug.Conn.t()) :: boolean()
  def aal3?(conn) do
    aal?(conn, 3)
  end

  @doc """
  Tests the sessions authenticator assurance level.
  """
  @doc since: "0.1.0"
  @spec aal?(Plug.Conn.t(), integer()) :: boolean()
  def aal?(conn, i) do
    session = conn.assigns[assign_key()]
    session.authenticator_assurance_level == "aal#{i}"
  end
end
