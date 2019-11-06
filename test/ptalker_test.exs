defmodule PtalkerTest do
  use ExUnit.Case
  doctest Ptalker

  test "greets the world" do
    assert Ptalker.hello() == :world
  end
end
