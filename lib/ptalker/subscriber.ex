defprotocol Ptalker.Subscriber do
  @doc """
  Sends the message to the subscriber.
  """
  def dispatch(subscriber, message)
end

defimpl Ptalker.Subscriber, for: Ptalker.StdoutSubscriber do
  def dispatch(subscriber, message) do
    Ptalker.StdoutSubscriber.dispatch(subscriber, message)
  end
end

defimpl Ptalker.Subscriber, for: Ptalker.TcpSubscriber do
  def dispatch(subscriber, message) do
    Ptalker.TcpSubscriber.dispatch(subscriber, message)
  end
end
