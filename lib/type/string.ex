defmodule Litmus.Type.String do
  @moduledoc false

  alias Litmus.Required

  defstruct [
    :min_length,
    :max_length,
    :length,
    :regex,
    trim: false,
    required: false
  ]

  @type t :: %__MODULE__{
          min_length: non_neg_integer,
          max_length: non_neg_integer,
          length: non_neg_integer,
          regex: term,
          trim: boolean,
          required: boolean
        }

  @spec validate_field(t, binary, map) :: {:ok, map} | {:error, binary}
  def validate_field(type, field, data) do
    with {:ok, data} <- Required.validate(type, field, data),
         {:ok, data} <- min_length_validate(type, field, data),
         {:ok, data} <- max_length_validate(type, field, data),
         {:ok, data} <- length_validate(type, field, data) do
      {:ok, data}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  @spec min_length_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  def min_length_validate(%Litmus.Type.String{min_length: min_length}, field, params)
      when min_length != nil and is_integer(min_length) and min_length >= 0 do
    if Map.has_key?(params, field) do
      if String.length(params[field]) >= min_length do
        {:ok, params}
      else
        {:error, "#{field} length must be more than or equal to #{min_length} characters long"}
      end
    else
      {:ok, params}
    end
  end

  def min_length_validate(%Litmus.Type.String{min_length: nil}, _field, params),
    do: {:ok, params}

  @spec max_length_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  def max_length_validate(%Litmus.Type.String{max_length: max_length}, field, params)
      when max_length != nil and is_integer(max_length) and max_length >= 0 do
    if Map.has_key?(params, field) do
      if String.length(params[field]) <= max_length do
        {:ok, params}
      else
        {:error, "#{field} length must be less than or equal to #{max_length} characters long"}
      end
    else
      {:ok, params}
    end
  end

  def max_length_validate(%Litmus.Type.String{max_length: nil}, _field, params),
    do: {:ok, params}

  @spec length_validate(t, binary, map) :: {:ok, map} | {:error, binary}
  def length_validate(%Litmus.Type.String{length: length}, field, params)
      when length != nil and is_integer(length) and length >= 0 do
    if Map.has_key?(params, field) do
      if String.length(params[field]) == length do
        {:ok, params}
      else
        {:error, "#{field} length must be #{length} characters long"}
      end
    else
      {:ok, params}
    end
  end

  def length_validate(%Litmus.Type.String{length: nil}, _field, params),
    do: {:ok, params}

  defimpl Litmus.Type do
    alias Litmus.Type

    @spec validate(Type.t(), binary, map) :: {:ok, map} | {:error, binary}
    def validate(type, field, data), do: Type.String.validate_field(type, field, data)
  end
end
