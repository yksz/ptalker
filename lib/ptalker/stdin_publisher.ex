defmodule Ptalker.StdinPublisher do
  @moduledoc """
  Documentation for Ptalker.
  """

  def start do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    IO.puts("StdinPublisher")
    # message = IO.read(:stdio, :line)
    message = "foobar"
    IO.puts("readline")
    Ptalker.publish(message)
    Process.sleep(3000)
    loop(map)
  end
end
