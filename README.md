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
iex> schema = %{
...> "id" => %Litmus.Type.Any{required: true},
...> "username" => %Litmus.Type.String{
...>   min_length: 6,
...>   required: true
...> },
...> "pin" => %Litmus.Type.Number{
...>   min: 1000,
...>   max: 9999,
...>   required: true
...> },
...> "new_user" => %Litmus.Type.Boolean{
...>   truthy: ["1"],
...>   falsy: ["0"]
...>  },
...> "account_ids" => %Litmus.Type.List{
...>   max_length: 3,
...>   type: "number"
...>  }
...> }
iex> params = %{"id" => 1, "username" => "user@123", "pin" => 1234, "new_user" => "1", "account_ids" => [1, 3, 9]}
iex> Litmus.validate(params, schema)
{:ok, %{"id" => 1, "new_user" => true, "pin" => 1234, "username" => "user@123", "account_ids" => [1, 3, 9]}}

iex> schema = %{"id" => %Litmus.Type.Any{}}
iex> params = %{"password" =>  1}
iex> Litmus.validate(params, schema)
{:error, "password is not allowed"}
```

Currently, we support the following data types:

* [**Any**](#module-litmus-type-any)
* [**Boolean**](#module-litmus-type-boolean)
* [**List**](#module-litmus-type-list)
* [**Number**](#module-litmus-type-number)
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

### Litmus.Type.Boolean

The `Boolean` module contains options that will validate Boolean data types. It converts truthy and falsy values to `true` or `false`. It supports the following options:
  * `:truthy` - Allows additional values, i.e. truthy values to be considered valid booleans by converting them to `true` during validation. Allowed value is an array of strings, number or boolean values. The default is `[true, "true"]`
  * `:falsy` - Allows additional values, i.e. falsy values to be considered valid booleans by converting them to `false` during validation. Allowed value is an array of strings, number or boolean values. The default is `[false, "false"]`

```
iex> schema = %{
...> "new_user" => %Litmus.Type.Boolean{
...>   truthy: ["1"],
...>   falsy: ["0"]
...>  }
...> }
iex> params = %{"new_user" => "1"}
iex> Litmus.validate(params, schema)
{:ok, %{"new_user" => true}}
iex> params = %{"new_user" => 0}
iex> Litmus.validate(params, schema)
{:error, "new_user must be a boolean"}
```

### Litmus.Type.List

The `List` module contains options that will validate List data types. It supports the following options:
  * `:min_length` - Specifies the minimum list length. Allowed values are non-negative integers.
  * `:max_length` - Specifies the maximum list length. Allowed values are non-negative integers.
  * `:length` - Specifies the exact list length. Allowed values are non-negative integers.
  * `:type` - Specifies the data type of elements in the list. Allowed values are binary or atom. Allowed data types are `atom, boolean, number and string`. Default value is `nil`. If `nil`, any element type is allowed in the list.

```
iex> schema = %{
...> "ids" => %Litmus.Type.List{
...>   min_length: 1,
...>   max_length: 5
...> },
...> "course_numbers" => %Litmus.Type.List{
...>   length: 3,
...>   type: "number"
...>  }
...> }
iex> params = %{"ids" => [1, "a"], "course_numbers" => [500, 523, 599]}
iex> Litmus.validate(params, schema)
{:ok, %{"ids" => [1, "a"], "course_numbers" => [500, 523, 599]}}
iex> params = %{"ids" => [1, "a"], "course_numbers" => [500, "523", 599]}
iex> Litmus.validate(params, schema)
{:error, "course_numbers must be a list of numbers"}
```

### Litmus.Type.Number

The `Number` module contains options that will validate Number data types. It converts "stringified" numerical values to numbers. It supports the following options:
  * `:min` - Specifies the minimum value of the field.
  * `:max` - Specifies the maximum value of the field.
  * `:integer` - Specifies that the number must be an integer (no floating point). Allowed values are `true` and `false`. The default is `false`.

```
iex> schema = %{
...> "id" => %Litmus.Type.Number{
...>   integer: true
...> },
...> "gpa" => %Litmus.Type.Number{
...>   min: 0,
...>   max: 4
...>  }
...> }
iex> params = %{"id" => "123", "gpa" => 3.8}
iex> Litmus.validate(params, schema)
{:ok, %{"id" => 123, "gpa" => 3.8}}
iex> params = %{"id" => "123.456", "gpa" => 3.8}
iex> Litmus.validate(params, schema)
{:error, "id must be an integer"}
```

### Litmus.Type.String

The `String` module contains options that will validate String data types. It converts boolean and number values to strings. It will also convert `nil` value to empty string. It supports the following options:
  * `:min_length` - Specifies the minimum number of characters needed in the string. Allowed values are non-negative integers.
  * `:max_length` - Specifies the maximum number of characters needed in the string. Allowed values are non-negative integers.
  * `:length` - Specifies the exact number of characters needed in the string. Allowed values are non-negative integers.
  * `:regex` - Specifies a Regular expression that a string must match. Allowed value is a struct consisting of `pattern` and `error_message`, where `pattern` is a `Regex` and `error_message` is a `String.t()` value. Default value for pattern is `nil`. If no error_message is given, the default message returned on error is `"#{field} must be in a valid format"`.
  * `:trim` - Removes additional whitespaces in a string and returns the new value. Allowed values are `true` and `false`. The default is `false`.

```
iex> schema = %{
...> "username" => %Litmus.Type.String{
...>   min_length: 3,
...>   max_length: 10,
...>   trim: true
...> },
...> "password" => %Litmus.Type.String{
...>   length: 6,
...>   regex: %Litmus.Type.String.Regex{
...>     pattern: ~r/^[a-zA-Z0-9_]*$/,
...>     error_message: "password must be alphanumeric"
...>   }
...>  }
...> }
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
