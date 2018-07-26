defmodule LitmusTest do
  use ExUnit.Case
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
            pattern: ~r/^[a-zA-Z0-9_]*$/
          },
          trim: true
        },
        "password" => %Litmus.Type.String{
          length: 4,
          required: true,
          trim: true
        },
        "zip_code" => %Litmus.Type.String{
          min_length: 5,
          regex: %Litmus.Type.String.Regex{
            pattern: ~r/^\d{3,}(?:[-\s]?\d*)?$/,
            error_message: "zip_code must be in a valid zip or zip+4 format"
          },
          trim: true
        }
      }

      req_params = %{
        "id" => "abc",
        "password" => "1234 ",
        "user" => "qwerty",
        "zip_code" => "94107-1741"
      }

      modified_params = Map.replace!(req_params, "password", String.trim(req_params["password"]))

      assert Litmus.validate(req_params, login_schema) == {:ok, modified_params}
    end

    test "errors when a disallowed parameter is passed" do
      login_schema = %{
        "id" => %Type.Any{
          required: true
        }
      }

      req_params = %{
        "id" => "1",
        "abc" => true
      }

      assert Litmus.validate(req_params, login_schema) == {:error, "abc is not allowed"}
    end
  end
end
