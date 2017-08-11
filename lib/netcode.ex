defmodule Netcode do
  use Application

  @moduledoc """
  Documentation for Netcode.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Netcode.hello
      :world

  """
  def hello do
    :world
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Netcode.Loop, [])
    ]

    # Start the main supervisor, and restart failed children individually
    opts = [strategy: :one_for_one, name: Netcode.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
