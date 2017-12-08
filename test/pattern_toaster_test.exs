defmodule PTTest do
  use ExUnit.Case
  doctest PT

  test "greets the world" do
    assert PT.hello() == :world
  end
end
