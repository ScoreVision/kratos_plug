defmodule KratosPlug.Config do
  @moduledoc """
  Module for configuration. `KratosPlug.Config` type is compatible with `Plug.opts()`.

  ## Keys

    - `:kratos_adapter` A module that implements the `KratosPlug.KratosClient` behaviour.
    - `:kratos_base_url` A base URL for kratos. A base URL includes protocol, host, and port only.
    - `:tesla_adapter` A module that implements the `Tesla.Adapter` behaviour.
  """

  @type runtime_opt :: {any(), fun()}
  @type key ::
          :kratos_adapter
          | :kratos_base_url
          | :tesla_adapter
          | atom()
  @type opt :: {key(), value()}
  @type value :: any()
  @type options :: [runtime_opt() | opt()]

  @doc """
  Returns a Keyword list of default options.

  ## Example

        iex> default_opts()
        [
          {:kratos_adapter, KratosPlug.KratosClient.TeslaAdapter},
          {:proxy_adapter, nil},
          {:kratos_base_url, nil},
          {:proxy_base_url, nil},
          {:tesla_adapter, Tesla.Adapter.Hackney}
        ]
  """
  @doc since: "0.1.0"
  @spec default_opts() :: Options.t()
  def default_opts(),
    do: [
      {:kratos_adapter, KratosPlug.KratosClient.TeslaAdapter},
      {:proxy_adapter, nil},
      {:kratos_base_url, nil},
      {:proxy_base_url, "http://localhost:4000"},
      {:tesla_adapter, Tesla.Adapter.Hackney}
    ]

  @doc """
  This function allows for the safe merger of default and implementor options.

  ## Example

        iex> merge_defaults([{:kratos_base_url, "http://kratos:80"}, {:non_standard, 0}])
        [
          {:kratos_adapter, KratosPlug.KratosClient.TeslaAdapter},
          {:proxy_adapter, KratosPlug.ProxyClient.TeslaAdapter},
          {:kratos_base_url, "http://kratos:80"},
          {:proxy_base_url, nil},
          {:non_standard, 0}
        ]

  """
  @doc since: "0.1.0"
  @spec merge_defaults(Keyword.t()) :: Keyword.t()
  def merge_defaults(opts) do
    Keyword.merge(default_opts(), opts, fn _, _, v2 -> v2 end)
  end

  @doc """
  This function allows for the graceful evaulation of runtime options.

  ## Example with Keyword list

        iex> eval_opts([{:foo, fn -> :bar end}, {:bar, :baz}])
        [{:foo, :bar}, {:bar, :baz}]

  ## Example with unsupported type

        iex> eval_opts(%{foo: fn -> :bar end, bar: :baz})
        %{foo: fn -> :bar end, bar: :baz}
  """
  @doc since: "0.1.0"
  @spec eval_opts(Options.t()) :: Options.t()
  ## Design note
  # An alternative would be to use apply/2 and apply/3.
  # However, this would require more options to be passed.
  # For this reason, and the fact that I have a working
  # solution, I am not going to change it at this time.
  #
  def eval_opts(opts) do
    for t <- opts, do: eval_opt(t)
  end

  @doc since: "0.1.0"
  @spec eval_opt(Options.runtime_opt()) :: Options.opt()
  defp eval_opt({k, v} = t)
       when tuple_size(t) == 2 and
              is_function(elem(t, 1)) do
    {k, v.()}
  end

  @doc since: "0.1.0"
  defp eval_opt(t) do
    t
  end
end
