defmodule Ptalker.StdoutSubscriber do
  @moduledoc """
  This is the subscriber module that sends the messages from the publishers to Stdout.
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
    require Logger
    Logger.info(message)
  end

  def dispatch(%Ptalker.StdoutSubscriber{pid: pid}, message) when pid != nil do
    send pid, {:dispatch, message}
  end
end
