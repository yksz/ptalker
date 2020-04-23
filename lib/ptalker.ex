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
    Ptalker.register_subscriber(%Ptalker.StdoutSubscriber{pid: pid2})
    IO.puts("subscriber")
    ready()
    :ok
  end

  def ready do
#    Ptalker.StdinPublisher.start()
    Ptalker.TcpPublisher.start(9000)
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
        Enum.each(subscribers, fn(subscriber) -> Ptalker.Subscriber.on_received(subscriber, message) end)
        loop(map)

      {:register_subscriber, subscriber} ->
        subscribers = map[:subscribers]
        subscribers = subscribers ++ [subscriber]
        #Enum.each(subscribers, fn(subscriber) -> IO.puts(subscriber) end)
        loop(%{map | :subscribers => subscribers})
    end
  end

  def publish(message) do
    send :ptalker, {:publish, message}
  end

  def register_subscriber(subscriber) do
    send :ptalker, {:register_subscriber, subscriber}
  end
end
