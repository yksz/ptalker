defmodule Ptalker.StdinPublisher do
  @moduledoc """
  This is the publisher module that sends the messages from Stdin to the subscribers.
  """

  @doc """
  Starts the process of this publisher.
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
