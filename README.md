# Litmus

Data validation in Elixir

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `litmus` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:litmus, "~> 0.1.0"}
  ]
end
```

## Usage

Validate data against a defined schema.

* `Litmus.validate/2`

If the data is valid, the function returns {:ok, data}. The data returned willbe coerced according to the schema defined.

If the data passed does not follow the rules defined in the schema, the function returns {:error, error_message}. It will also return error, in case we have a field in data, whose rule is not defined in the schema.

```elixir
iex> schema = %{"id": %Litmus.Type.Any{"required": true}}
iex> params = %{"id": 1}
iex> Litmus.validate(params, schema)
{:ok, %{id: 1}}

iex> schema = %{"id": %Litmus.Type.Any{}}
iex> params = %{"password": 1}
iex> Litmus.validate(params, schema)
{:error, "password is not allowed"}
```

Currently, we support the following data types:

* [**Any**](#any)

## Data Types Supported

# any

It will contain functions which will be common to all data types. It supports the following functions:
  * *Required*

```
iex> schema = %{"id": %Litmus.Type.Any{"required": true}}
iex> params = %{"id": 1}
iex> Litmus.validate(params, schema)
{:ok, %{id: 1}}

iex> schema = %{"id": %Litmus.Type.Any{}}
iex> params = %{}
iex> Litmus.validate(params, schema)
{:ok, %{}}

iex> schema = %{"id": %Litmus.Type.Any{"required": true}}
iex> params = %{}
iex> Litmus.validate(params, schema)
{:error, "id is required"}

iex> schema = %{"id": %Litmus.Type.Any{"required": "true"}}
iex> params = %{"id": 1}
iex> Litmus.validate(params, schema)
{:error, "Any.required must be a boolean"}
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/litmus](https://hexdocs.pm/litmus).

