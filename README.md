# Litmus

![Hex.pm](https://img.shields.io/hexpm/v/litmus.svg)
[![Build Docs](https://img.shields.io/badge/hexdocs-release-blue.svg)](https://hexdocs.pm/litmus/Litmus.html)
[![Build Status](https://travis-ci.org/lob/litmus.svg?branch=master)](https://travis-ci.org/lob/litmus)

Data validation in Elixir

## Installation

The package can be installed by adding `litmus` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:litmus, "~> 0.6.0"}
  ]
end
```

## Usage

Litmus validates data against a predefined schema with the `Litmus.validate/2`
function.

If the data is valid, the function returns `{:ok, data}`. The data returned
will be coerced according to the provided schema.

If the data passed does not follow the rules defined in the schema, the
function returns `{:error, error_message}`. It will also return an error when
receiving a field that has not been specified in the provided schema.

```elixir
schema = %{
  "id" => %Litmus.Type.Any{
    required: true
  },
  "username" => %Litmus.Type.String{
    min_length: 6,
    required: true
  },
  "pin" => %Litmus.Type.Number{
    min: 1000,
    max: 9999,
    required: true
  },
  "new_user" => %Litmus.Type.Boolean{
    truthy: ["1"],
    falsy: ["0"]
   },
  "account_ids" => %Litmus.Type.List{
    max_length: 3,
    type: :number
  },
  "remember_me" => %Litmus.Type.Boolean{
    default: false
  }
}

params = %{
  "id" => 1,
  "username" => "user@123",
  "pin" => 1234,
  "new_user" => "1",
  "account_ids" => [1, 3, 9]
}

Litmus.validate(params, schema)
# => {:ok,
#      %{
#        "id" => 1,
#        "new_user" => true,
#        "pin" => 1234,
#        "username" => "user@123",
#        "account_ids" => [1, 3, 9],
#        "remember_me" => false
#      }
#    }

Litmus.validate(%{}, schema)
# => {:error, "id is required"}
```

## Supported Types

Litmus currently supports the following types.

* `Litmus.Type.Any`
* `Litmus.Type.Boolean`
* `Litmus.Type.DateTime`
* `Litmus.Type.List`
* `Litmus.Type.Number`
* `Litmus.Type.String`

## Plug Integration

Litmus comes with a Plug for easy integration with Plug's built-in router. You can automatically validate query
parameters and body parameters by passing the `litmus_query` and `litmus_body` private options to each route. When
declaring the plug you must include a `on_error/2` function to be called when validation fails. It is recommended that
you initialize this Plug between the `:match` and `:dispatch` plugs. If you want processing to stop on a validation
error, be sure to halt the request with `Plug.Conn.halt/1`.

#### Example

```elixir
defmodule MyRouter do
  use Plug.Router

  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])

  plug(:match)

  plug(Litmus.Plug, on_error: &__MODULE__.on_error/2)

  plug(:dispatch)

  @schema %{
    "id" => %Litmus.Type.Number{
      required: true
    }
  }

  get "/test", private: %{litmus_query: @schema} do
    Plug.Conn.send_resp(conn, 200, "items")
  end

  post "/test", private: %{litmus_body: @schema} do
    Plug.Conn.send_resp(conn, 200, "items")
  end

  def on_error(conn, error_message) do
    conn
    |> Plug.Conn.send_resp(400, error_message)
    |> Plug.Conn.halt()
  end
end
```
