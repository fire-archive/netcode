# Netcode

**TODO: Add description**

## Installation

Install Ubuntu 16.04 deps `sudo apt install libsodium-dev make build-essential erlang-dev`

Install libsodium in Ubuntu 16.04. 
```
sudo apt-get install -y software-properties-common
sudo bash -c "LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php"
sudo apt-get update
sudo apt-get install -y libsodium-dev
```

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `netcode` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:netcode, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/netcode](https://hexdocs.pm/netcode).

## Based on

http://www.rokkincat.com/blog/2016/05/09/parsing-udp-in-elixir-with-binary-pattern-matching
