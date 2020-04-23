defmodule Ptalker.TcpSubscriber do
  defstruct pid: nil

  def start do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:on_received, message} ->
        IO.puts("TcpSubscriber: on_received: " <> message)
        loop(map)
    end
  end

  def on_received(%Ptalker.TcpSubscriber{pid: pid}, message) when pid != nil do
    # connect and send message
    send pid, {:on_received, message}
  end
end
