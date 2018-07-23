defmodule LitmusTest do
  use ExUnit.Case
  doctest Litmus

  alias Litmus.Type

  test "validates data according to a schema" do
    login_schema = %{
      id: %Type.Any{
        required: true
      }
      # username: %Type.String{
      #   min_length: 3,
      #   max_length: 15,
      #   regex: "^[a-zA-Z0-9_]+$"
      # },
      # num_of_accounts: %Type.Number{
      #   min: 0,
      #   max: 10,
      #   integer: true
      # },
      # feature_flag: %Type.Boolean{
      #   truthy: ["yes", "1"],
      #   falsy: ["no", "0"]
      # }
    }

    req_params = %{
      id: "1"
    }

    assert Litmus.validate(req_params, login_schema) == {:ok, req_params}
  end

  test "errors when a disallowed parameter is passed" do
    login_schema = %{
      id: %Type.Any{
        required: true
      }
    }

    req_params = %{
      id: "1",
      abc: true
    }

    assert Litmus.validate(req_params, login_schema) == {:error, "abc is not allowed"}
  end
end
