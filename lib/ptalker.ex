defmodule Ptalker do
  @moduledoc """
  This is the Ptalker module.
  """

  @process_name :ptalker

  @doc """
  Starts Ptalker.

  ## Options
    * `:restart` - (boolean) when true, kills the process of Ptalker if it is already running.

  ## Examples

      iex> Ptalker.start()
      :ok

  """
  def start(options \\ []) do
    {:ok, pid} = Task.start_link(fn -> message_loop(%{:subscribers => []}) end)
    Process.register(pid, @process_name)

    start_publishers()
    start_subscribers()
    :ok
  end

  defp start_publishers(options \\ []) do
    IO.puts("start_publishers")
    Ptalker.StdinPublisher.start()
    # Ptalker.TcpPublisher.start(9000)
  end

  defp start_subscribers(options \\ []) do
    IO.puts("start_subscribers")
    {:ok, pid} = Ptalker.StdoutSubscriber.start()
    Ptalker.register_subscriber(%Ptalker.StdoutSubscriber{pid: pid})
  end

  def stop(options \\ []) do
    pname = @process_name
    pid = Process.whereis(pname)
    if pid != nil do
      Process.unregister(pname)
      Process.exit(pid, :kill)
    end
  end

  defp message_loop(map) do
    receive do
      {:publish, message} ->
        subscribers = map[:subscribers]
        Enum.each(subscribers, fn(subscriber) -> Ptalker.Subscriber.dispatch(subscriber, message) end)
        message_loop(map)

      {:register_subscriber, subscriber} ->
        subscribers = map[:subscribers]
        subscribers = subscribers ++ [subscriber]
        message_loop(%{map | :subscribers => subscribers})
    end
  end

  @doc """
  Requests the message to Ptalker.

  ## Message Format

    * Publish

        {
          "op": "publish",
          "topic": <string>,
          "msg": <json>
        }

    * Subscribe

        {
          "op": "subscribe",
          "topic": <string>,
          "url": <string>
        }

    * Unsubscribe

        {
          "op": "unsubscribe",
          "topic": <string>,
          (optional) "url": <string>
        }

    * Get Subscribers
        {
          "op": "get_subscribers"
        }

  """
  def request(json_message) do
    message = Poison.decode!(json_message)
    case message do
      %{op: "publish"}     -> publish(message.msg)
      %{op: "subscribe"}   -> subscribe(message.topic)
      %{op: "unsubscribe"} -> unsubscribe(message.topic)
      _ -> IO.puts("error: " <> message)
    end
  end

  @doc """
  Publishes the message to the registered subscribers.
  """
  def publish(message) do
    send @process_name, {:publish, message}
  end

  @doc """
  Subscribes the topic.
  """
  def subscribe(topic, ) do
    send @process_name, {:register_subscriber, subscriber}
  end

  @doc """
  Unsubscribes the topic.
  """
  def unsubscribe(topic, ) do
    send @process_name, {:unregister_subscriber, subscriber}
  end

  @doc """
  Registers the subscriber.
  """
  def register_subscriber(subscriber) do
    send @process_name, {:register_subscriber, subscriber}
  end

  @doc """
  Unregisters the subscriber.
  """
  def unregister_subscriber(subscriber) do
    send @process_name, {:unregister_subscriber, subscriber}
  end
end
