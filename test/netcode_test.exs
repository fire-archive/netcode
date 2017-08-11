defmodule NetcodeTest do
  use ExUnit.Case
  doctest Netcode

  test "greets the world" do
    assert Netcode.hello() == :world
  end
end
