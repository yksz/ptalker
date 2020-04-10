defmodule Ptalker.StdoutSubscriber do
  @moduledoc """
  Documentation for Ptalker.
  """

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

  def on_received(pid, message) do
    send pid, {:on_received, message}
  end
end
