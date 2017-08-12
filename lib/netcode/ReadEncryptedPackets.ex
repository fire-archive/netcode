defmodule Netcode.ReadEncryptedPacket do
  @moduledoc """
The following steps are taken when reading an encrypted packet, in this exact order:

If the packet size is less than 18 bytes then it is too small to possibly be valid, ignore the packet.

If the low 4 bits of the prefix byte are greater than or equal to 7, the packet type is invalid, ignore the packet.

The server ignores packets with type connection challenge packet.

The client ignores packets with type connection request packet and connection response packet.

If the high 4 bits of the prefix byte (sequence bytes) are outside the range [1,8], ignore the packet.

If the packet size is less than 1 + sequence bytes + 16, it cannot possibly be valid, ignore the packet.

If the packet type fails the replay protection test, ignore the packet. See the section on replay protection below for details.

If the per-packet type data fails to decrypt, ignore the packet.

If the per-packet type data size does not match the expected size for the packet type, ignore the packet.

* 0 bytes for connection denied packet
* 308 bytes for connection challenge packet
* 308 bytes for connection response packet
* 8 bytes for connection keep-alive packet
* [1,1200] bytes for connection payload packet
* 0 bytes for connection disconnect packet
* If all the above checks pass, the packet is processed.

----
connect token expired (-6)
invalid connect token (-5)
connection timed out (-4)
connection response timed out (-3)
connection request timed out (-2)
connection denied (-1)
disconnected (0)
sending connection request (1)
sending connection response (2)
connected (3)
# The initial state is disconnected (0). Negative states represent error states. The goal state is connected (3).

handle(:start, data)
case data do
  size(data) -> :ignore
  check_prefix_byte(data) -> :ignore
  ignore_connection_challenge -> :ignore
  ignore_connection_request -> :ignore
  ignore_connection_response -> :ignore
  check_packet_size(data) -> :ignore
  check_replay_protection(data) -> :ignore
  data -> decrypt(data)
end

def decrypt(data) do
  case actual_decrypt(data) do
  {:ok, plain} = x ->
    type = get_packet_type(plain)
    case type do
      :connection_denied and size(plain) == 0 -> plain
      :connection_challenge and size(plain) == 308 -> plain
      :connection_response and size(plain) == 308 -> plain
      :connection_keep_alive and size(plain) == 8 -> plain
      :connection_payload and size(plain) => 1 and size(plain) <= 1200 -> plain
      :connection_disconnect and size(plain) == 0 -> plain
      _ -> :ignore
    end
  end
end

def check_packet_size(data) do
case size(data) do
end
end

---

If the packet is not the expected size of 1062 bytes, ignore the packet.

If the version info in the packet doesn't match "NETCODE 1.00" (13 bytes, with null terminator), ignore the packet.

If the protocol id in the packet doesn't match the expected protocol id of the dedicated server, ignore the packet.

If the connect token expire timestamp is <= the current timestamp, ignore the packet.

If the encrypted private connect token data doesn't decrypt with the private key, using the associated data constructed from: version info, protocol id and expire timestamp, ignore the packet.

If the decrypted private connect token fails to be read for any reason, for example, having a number of server addresses outside of the expected range of [1,32], or having an address type value outside of range [0,1], ignore the packet.

If the dedicated server public address is not in the list of server addresses in the private connect token, ignore the packet.

If a client from the packet IP source address and port is already connected, ignore the packet.

If a client with the client id contained in the private connect token data is already connected, ignore the packet.

If the connect token has already been used by a different packet source IP address and port, ignore the packet.

Otherwise, add the private connect token hmac + packet source IP address and port to the history of connect tokens already used.

If no client slots are available, then the server is full. Respond with a connection denied packet.

Add an encryption mapping for the packet source IP address and port so that packets read from that address and port are decrypted with the client to server key in the private connect token, and packets sent to that address and port are encrypted with the server to client key in the private connect token. This encryption mapping expires in timeout seconds of no packets being sent to or received from that address and port, or if a client fails to establish a connection with the server within timeout seconds.

If for some reason this encryption mapping cannot be added, ignore the packet.

Otherwise, respond with a connection challenge packet and increment the connection challenge sequence number.


:processing_connection_requests
:processing_connection_response
:connected
:
"""
  use GenStateMachine, callback_mode: :state_functions

  def off(:cast, :flip, data) do
    {:next_state, :on, data + 1}
  end
  def off(event_type, event_content, data) do
    handle_event(event_type, event_content, data)
  end

  def on(:cast, :flip, data) do
    {:next_state, :off, data}
  end
  def on(event_type, event_content, data) do
    handle_event(event_type, event_content, data)
  end

  def handle_event({:call, from}, :get_count, data) do
    {:keep_state_and_data, [{:reply, from, data}]}
  end
end
