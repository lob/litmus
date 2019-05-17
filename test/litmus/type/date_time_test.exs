defmodule Litmus.Type.DateTimeTest do
  use ExUnit.Case, async: true
  doctest Litmus.Type.DateTime

  alias Litmus.Type

  @field "start_date"

  describe "validate_field/3" do
    test "converts a string to a datetime" do
      data = %{@field => "1990-05-01T06:32:00Z"}

      {:ok, expected_date_time, _} = DateTime.from_iso8601(data[@field])
      expected_data = %{@field => expected_date_time}

      type = %Type.DateTime{
        required: true
      }

      assert Type.DateTime.validate_field(type, @field, data) == {:ok, expected_data}
    end

    test "does not alter nil" do
      data = %{@field => nil}

      type = %Type.DateTime{}

      assert Type.DateTime.validate_field(type, @field, data) == {:ok, data}
    end

    test "allows DateTimes" do
      {:ok, datetime, _} = DateTime.from_iso8601("1999-01-05T05:00:00Z")
      data = %{@field => datetime}

      type = %Type.DateTime{
        required: true
      }

      assert Type.DateTime.validate_field(type, @field, data) == {:ok, data}
    end

    test "errors when required datetime is not provided" do
      data = %{}

      type = %Type.DateTime{
        required: true
      }

      assert Type.DateTime.validate_field(type, @field, data) ==
               {:error, "start_date is required"}
    end

    test "errors when the value is not a string" do
      data = %{@field => 1234}

      type = %Type.DateTime{
        required: true
      }

      assert Type.DateTime.validate_field(type, @field, data) ==
               {:error, "start_date must be a valid ISO-8601 datetime"}
    end

    test "errors when the value is not in an ISO-8601 datetime with timezone format" do
      data = %{@field => "2018-06-01"}

      type = %Type.DateTime{
        required: true
      }

      assert Type.DateTime.validate_field(type, @field, data) ==
               {:error, "start_date must be a valid ISO-8601 datetime"}
    end
  end
end
