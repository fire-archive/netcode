defmodule Netcode.ConnectToken do
  use Tonic, optimize: true

  endian :little

  string :version_info, length: 13 # "NETCODE 1.00" ASCII with null terminator
  uint64 :protocol_id # 64 bit value unique to this particular game/application
  uint64 :create_timestamp # 64 bit unix timestamp when this connect token was created
  uint64 :expire_timestamp # 64 bit unix timestamp when this connect token expires
  uint64 :connect_token_sequence
  uint8 :encrypted_private_connect_token_data, 1024
  uint32 :num_server_addresses 
  repeat :server_address, Netcode.ConnectTokenData.verify_num_servers(get(:num_server_addresses)) do
    uint8 :address_type
    on get(:address_type) do
      # value of 1 = IPv4 address, 2 = IPv6 address.
      1 ->
        # for a given IPv4 address: a.b.c.d:port
        uint8 :a
        uint8 :b
        uint8 :c
        uint8 :d
        uint16 :port
      2 ->
        # for a given IPv6 address: [a:b:c:d:e:f:g:h]:port
        uint16 :a
        uint16 :b
        uint16 :c
        uint16 :d
        uint16 :e
        uint16 :f
        uint16 :g
        uint16 :h
        uint16 :port
    end
  end
  uint8 :client_to_server_key, length: 32
  uint8 :server_to_client_key, length: 32
  uint32 :timeout_seconds
  repeat :zero_pad do
    repeat :uint8
  end
end
