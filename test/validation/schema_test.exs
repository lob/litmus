defmodule Litmus.Validation.SchemaTest do
  use ExUnit.Case

  alias Litmus.Type
  alias Litmus.Validation.Schema

  test "check data against defined schema" do
    login_schema = %{
      "id": %Type.Any{
        "required": true
      },
      "username": %Type.String{
        "min_length": 3,
        "max_length": 15,
        "regex": "^[a-zA-Z0-9_]+$",
        "required": false
      },
      "num_of_accounts": %Type.Number{
        "min": 0,
        "max": 10
      },
      "feature_flag": %Type.Boolean{
        "truthy": ["yes", "1"],
        "falsy": ["no", "0"]
      }
    }

    req_params = %{
      "id": "1"
    }
    result = Schema.check_schema_error(req_params, login_schema)
    assert result == {:ok, req_params}
  end
end
