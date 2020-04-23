defprotocol Ptalker.Subscriber do
  def on_received(subscriber, message)
end

defimpl Ptalker.Subscriber, for: Ptalker.StdoutSubscriber do
  def on_received(subscriber, message) do
    Ptalker.StdoutSubscriber.on_received(subscriber, message)
  end
end
