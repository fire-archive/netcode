defmodule Netcode.Loop do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init (:ok) do
    {:ok, _socket} = :gen_udp.open(21337)
  end

  # Handle UDP data
  def handle_info({:udp, _socket, _ip, _port, data}, state) do
    IO.puts inspect(data)
    {:noreply, state}
  end

  # Ignore everything else
  def handle_info({_, _socket}, state) do
    {:noreply, state}
  end
end
