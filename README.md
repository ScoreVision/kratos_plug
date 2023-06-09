# KratosPlug

Provides authentication to [Plug](https://github.com/elixir-plug/plug) applications by integrating with [Ory Kratos](https://github.com/ory/kratos).

KratosPlug is a composable library for extracting session identifiers from the request, and exchanging them for a kratos session. KratosPlug also provides functions like `KratosPlug.session_valid?/1` for working with sessions. _This is not an official [Ory Corp](https://ory.sh) project._

## What is Kratos?

> Ory Kratos is the developer-friendly, security-hardened and battle-tested Identity, User Management and Authentication system for the Cloud. Finally, it is no longer necessary to implement User Login for the umpteenth time!

## Plugs

- `KratosPlug.Plugs.KratosSession` forwards request data from the conn to the kratos API. The session returned by kratos is added to the conn. This plug will not halt for any reason.
- `KratosPlug.Plugs.EnsureAuthenticated` checks the conn for a kratos session and halts when missing or invalid.
- `KratosPlug.Plugs.KratosNativePipeline` executes both `KratosSession` and `EnsureAuthenticated` and passes along configuration options unchanged.

## Setup

### Add the dependency

```elixir
# mix.exs

defp deps do
  [{:kratos_plug, "~>0.1"}]
end
```

### Add pipeline to router

```elixir
# router.ex

defmodule MyRouter do
  use Plug.Router

  alias KratosPlug.Plugs.KratosNativePipeline, [{:kratos_base_url, "http://localhost:4433"}]
  plug :match
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  forward "/users", to: UsersRouter

  match _ do
    send_resp(conn, 404, "oops")
  end
end
```

## Configuring plugs

`KratosPlug.Config` describes the available plug configuration options. Runtime configuration is supported by providing an anonymous function as the configuration value.

## Library State

It is __not__ ready for production use. The library has had only preliminary testing, but so far it has been successful.

## Ory proxy and JWT support

Ory proxy and JSON Web Tokens (JWT) are unsupported.

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/kratos_plug>.

## Versioning

This project uses [semantic versioning 2.0.0](https://semver.org/).

>1. MAJOR version when you make incompatible API changes
>2. MINOR version when you add functionality in a backward compatible manner
>3. PATCH version when you make backward compatible bug fixes

## Releases

See `CHANGELOG.md`

## Copyright and License

Copyright (c) 2023 ScoreVision, LLC

Released under the MIT License. See `LICENSE.md`
