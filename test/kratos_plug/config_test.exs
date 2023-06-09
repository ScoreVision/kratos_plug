defmodule KratosPlug.ConfigTest do
  use ExUnit.Case, async: true
  import Keyword, only: [equal?: 2]

  test "default_opts/0" do
    assert equal?(
             [
               {:kratos_adapter, KratosPlug.KratosClient.TeslaAdapter},
               {:proxy_adapter, nil},
               {:kratos_base_url, nil},
               {:proxy_base_url, "http://localhost:4000"},
               {:tesla_adapter, Tesla.Adapter.Hackney}
             ],
             KratosPlug.Config.default_opts()
           )
  end

  test "merge_defaults/1" do
    assert equal?(
             [
               {:kratos_adapter, KratosPlug.KratosClient.TeslaAdapter},
               {:proxy_adapter, nil},
               {:kratos_base_url, "http://kratos:80"},
               {:proxy_base_url, "http://localhost:4000"},
               {:tesla_adapter, Tesla.Adapter.Hackney},
               {:non_standard, 0}
             ],
             KratosPlug.Config.merge_defaults([
               {:kratos_base_url, "http://kratos:80"},
               {:non_standard, 0}
             ])
           )
  end

  test "merge_defaults/1 empty keywords" do
    assert equal?(
             [
               {:kratos_adapter, KratosPlug.KratosClient.TeslaAdapter},
               {:proxy_adapter, nil},
               {:kratos_base_url, nil},
               {:proxy_base_url, "http://localhost:4000"},
               {:tesla_adapter, Tesla.Adapter.Hackney}
             ],
             KratosPlug.Config.merge_defaults([])
           )
  end

  test "eval_opts/1" do
    assert equal?(
             [{:foo, :bar}, {:bar, :baz}],
             KratosPlug.Config.eval_opts([{:foo, fn -> :bar end}, {:bar, :baz}])
           )
  end
end
