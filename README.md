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

Litmus validates data against a predefined schema with the `Litmus.validate/2` function.

If the data is valid, the function returns `{:ok, data}`. The data returned will be coerced according to the schema defined.

If the data passed does not follow the rules defined in the schema, the function returns `{:error, error_message}`. It will also return an error when receiving a field that has not been specified in the provided schema.

```elixir
iex> schema = %{"id" => %Litmus.Type.Any{required: true}}
iex> params = %{"id" => 1}
iex> Litmus.validate(params, schema)
{:ok, %{"id" => 1}}

iex> schema = %{"id" => %Litmus.Type.Any{}}
iex> params = %{"password" =>  1}
iex> Litmus.validate(params, schema)
{:error, "password is not allowed"}
```

Currently, we support the following data types:

* [**Any**](#module-litmus-type-any)
* [**String**](#module-litmus-type-string)

## Data Types Supported

### Litmus.Type.Any

The `Any` module contains options that will be common to all data types. It supports the following options:
  * `:required` - Setting `required` to `true` will cause a validation error when a field is not present or the value is `nil`. Allowed values for required are `true` and `false`. The default is `false`.

```
iex> schema = %{"id" => %Litmus.Type.Any{required: true}}
iex> params = %{"id" => 1}
iex> Litmus.validate(params, schema)
{:ok, %{"id" => 1}}
iex> params = %{}
iex> Litmus.validate(params, schema)
{:error, "id is required"}
```

### Litmus.Type.String

The `String` module contains options that will validate String data types. It supports the following options:
  * `:min_length` - Specifies the minimum number of characters needed in the string. Allowed values are non-negative integers.
  * `:max_length` - Specifies the maximum number of characters needed in the string. Allowed values are non-negative integers.
  * `:length` - Specifies the exact number of characters needed in the string. Allowed values are non-negative integers.
  * `:regex` - Specifies a Regular expression that a string must match. Allowed value is a struct consisting of `pattern` and `error_message`, where `pattern` is a `Regex` and `error_message` is a `binary` value. Default value for pattern is `nil`. If no error_message is given, the default message returned on error is `"#{field} must be in a valid format"`.
  * `:trim` - Removes additional whitespaces in a string and returns the new value. Allowed values are `true` and `false`. The default is `false`.

```
iex> schema = %{"username" => %Litmus.Type.String{min_length: 3, max_length: 10, trim: true}, "password" => %Litmus.Type.String{length: 6, regex: %Litmus.Type.String.Regex{pattern: ~r/^[a-zA-Z0-9_]*$/, error_message: "password must be alphanumeric"}}}
iex> params = %{"username" => " user123 ", "password" => "root01"}
iex> Litmus.validate(params, schema)
{:ok, %{"username" => "user123", "password" => "root01"}}
iex> params = %{"username" => " user123 ", "password" => "ro!_@1"}
iex> Litmus.validate(params, schema)
{:error, "password must be alphanumeric"}
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/litmus](https://hexdocs.pm/litmus).

