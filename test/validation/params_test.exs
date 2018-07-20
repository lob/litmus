defmodule Litmus.Validation.ParamsTest do
  use ExUnit.Case

  alias Litmus.Type
  alias Litmus.Validation.Params

  test "return ok when no additional parameters are passed" do
    login_schema = %{
      id: %Type.Any{
        required: true
      }
    }

    req_params = %{
      id: "1"
    }

    assert Params.check_additional_params_error(req_params, login_schema) == {:ok, nil}
  end

  test "return error when an additional parameter is passed" do
    login_schema = %{
      id: %Type.Any{
        required: true
      }
    }

    req_params = %{
      id: "1",
      abc: true
    }

    assert Params.check_additional_params_error(req_params, login_schema) ==
             {:error, "The data has following additional parameters: abc"}
  end
end
