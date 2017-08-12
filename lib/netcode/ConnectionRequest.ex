defmodule Netcode.ConnectionRequest do
  use Tonic, optimize: true

  endian :little

  uint8 :prefix_byte

  string :version_info, length: 13 # "NETCODE 1.00" ASCII with null terminator
  uint64 :protocol_id # 64 bit value unique to this particular game/application
end
