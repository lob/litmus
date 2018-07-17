defmodule LitmusTest do
  use ExUnit.Case
  doctest Litmus

  test "greets the world" do
    assert Litmus.hello() == :world
  end
end
