defmodule KratosPlug.KratosClient do
  @moduledoc """
  Behaviour to implement a Kratos session request.
  """
  @moduledoc since: "0.1.0"
  alias KratosPlug.Config.Options
  alias KratosPlug.Identifiers

  @callback who_am_i(Identifiers.t(), Options.t()) ::
              {:ok, map()} | {:error, binary()} | {:error, map()}
end
