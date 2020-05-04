defmodule Ptalker.TcpSubscriber do
  @moduledoc """
  This is the subscriber module that sends the messages from the publishers to the TCP client.
  """

  defstruct pid: nil

  def start do
    Task.start_link(fn -> message_loop(%{}) end)
  end

  defp message_loop(map) do
    receive do
      {:dispatch, message} ->
        broadcast(message)
        message_loop(map)
    end
  end

  defp broadcast(message) do
    # Connect and send message to the host
    IO.puts("TcpSubscriber: " <> message)
  end

  def dispatch(%Ptalker.TcpSubscriber{pid: pid}, message) when pid != nil do
    send pid, {:dispatch, message}
  end
end
