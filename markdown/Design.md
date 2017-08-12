# 

## Encrypt and decrypt design

How do I use crypto_aead_chacha20poly1305_ietf_encrypt?

M = Encryption of the private connect token data 

AD = 
[version info] (13 bytes)       // "NETCODE 1.00" ASCII with null terminator.
[protocol id] (uint64)          // 64 bit value unique to this particular game/application
[expire timestamp] (uint64)     // 64 bit unix timestamp when this connect token expires

NPub =
The nonce used for encryption is a 64 bit sequence number that starts at zero and increases with each connect token generated. The sequence number is extended by padding high bits with zero to create a 96 bit nonce. Each nonce can only be used once.

```elixir
nounce = :crypto.strong_rand_bytes(12)
key = :crypto.strong_rand_bytes(32)
message = <<"123">>
associated_data = <<"321">>

# ietf_encrypt(M, AD, NPub, K)
encrypted = :libsodium_crypto_aead_chacha20poly1305.ietf_encrypt(message, associated_data, nounce, key)

# :ietf_decrypt(C, AD, NPub, K)
:libsodium_crypto_aead_chacha20poly1305.ietf_decrypt(encrypted, associated_data, nounce, key)
````

## Netcode.io design

Server key encrypts private connect token.

Generate two crypto secure random 32 bytes for the client to server and server to client key. 

Public and private data form a connect token.

Encrypted has associated data which is version info, protocol id and prefix byte.

Packets sent from client to server are encrypted with the client to server key in the connect token.

Packets sent from server to client are encrypted using the server to client key in the connect token for that client.