defmodule LitmusTest do
  use ExUnit.Case, async: true
  doctest Litmus

  alias Litmus.Type

  describe "validate/2" do
    test "validates data according to a schema" do
      login_schema = %{
        "id" => %Litmus.Type.Any{
          required: true
        },
        "user" => %Litmus.Type.String{
          max_length: 6,
          min_length: 3,
          regex: %Litmus.Type.String.Regex{
            pattern: ~r/^[a-zA-Z0-9_]*$/,
            error_message: "username must be alphanumeric"
          },
          trim: true
        },
        "password" => %Litmus.Type.String{
          length: 4,
          required: true,
          trim: true
        },
        "pin" => %Litmus.Type.Number{
          min: 1000,
          max: 9999,
          integer: true
        },
        "remember_me" => %Litmus.Type.Boolean{
          truthy: [1],
          falsy: [0]
        },
        "account_ids" => %Litmus.Type.List{
          type: :number,
          min_length: 2,
          max_length: 5
        },
        "start_date" => %Litmus.Type.DateTime{}
      }

      params = %{
        "id" => "abc",
        "password" => " 1234 ",
        "user" => "qwerty",
        "pin" => 3636,
        "remember_me" => 1,
        "account_ids" => [523, 524, 599],
        "start_date" => "1990-05-01T06:32:00Z"
      }

      modified_params = %{
        params
        | "password" => String.trim(params["password"]),
          "remember_me" => true,
          "start_date" => params["start_date"] |> DateTime.from_iso8601() |> elem(1)
      }

      assert Litmus.validate(params, login_schema) == {:ok, modified_params}
    end

    test "errors when a disallowed parameter is passed" do
      login_schema = %{
        "id" => %Type.Any{
          required: true
        }
      }

      params = %{
        "id" => "1",
        "abc" => true
      }

      assert Litmus.validate(params, login_schema) == {:error, "abc is not allowed"}
    end
  end
end
