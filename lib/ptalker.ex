defmodule Ptalker do
  @moduledoc """
  Documentation for Ptalker.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Ptalker.hello()
      :world

  """
  def hello do
    :world
  end

  def start do
    {:ok, pid} = Task.start_link(fn -> loop(%{:subscribers => []}) end)
    Process.register(pid, :ptalker)

    {:ok, pid2} = Ptalker.StdoutSubscriber.start()
    Ptalker.register_subscriber(pid2)
    IO.puts("subscriber")
    :ok
  end

  def ready do
    Ptalker.StdinPublisher.start()
    IO.puts("publisher")
  end

  defp loop(map) do
    IO.puts("loop")
    receive do
      {:hello, message} ->
        IO.puts("Hello " <> message)
        loop(map)

      {:publish, message} ->
        subscribers = map[:subscribers]
        IO.puts("published: " <> message)
        Enum.each(subscribers, fn(subscriber) -> Ptalker.StdoutSubscriber.on_received(subscriber, message) end)
        loop(map)

      {:register_subscriber, pid} ->
        subscribers = map[:subscribers]
        subscribers = subscribers ++ [pid]
        #Enum.each(subscribers, fn(subscriber) -> IO.puts(subscriber) end)
        loop(%{map | :subscribers => subscribers})
    end
  end

  def publish(message) do
    send :ptalker, {:publish, message}
  end

  def register_subscriber(pid) do
    send :ptalker, {:register_subscriber, pid}
  end
end
