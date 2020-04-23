defmodule Ptalker.StdoutSubscriber do
  defstruct pid: nil

  def start do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:on_received, message} ->
        IO.puts("StdoutSubscriber: on_received: " <> message)
        loop(map)
    end
  end

  def on_received(%Ptalker.StdoutSubscriber{pid: pid}, message) when pid != nil do
    send pid, {:on_received, message}
  end
end
