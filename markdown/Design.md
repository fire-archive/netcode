# 

## Encrypt and decrypt design

How do I use crypto_aead_chacha20poly1305_ietf_encrypt?

M = Encryption of the private connect token data 

AD = 
[version info] (13 bytes)       // "NETCODE 1.00" ASCII with null terminator.
[protocol id] (uint64)          // 64 bit value unique to this particular game/application
[expire timestamp] (uint64)     // 64 bit unix timestamp when this connect token expires

NPub =
The nonce used for encryption is a 64 bit sequence number that starts at zero and increases with each connect token generated. The sequence number is extended by padding high bits with zero to create a 96 bit nonce.

K = Key (Random 32 Bytes)

:crypto.strong_rand_bytes(32)

:libsodium_crypto_aead_chacha20poly1305.ietf_encrypt(<<"123">>, <<"321">>, <<185, 201, 166, 203, 130, 189, 171, 255, 243, 96, 77, 205>>, <<213, 87, 15, 192, 21, 200, 200, 142, 201, 31, 132, 120, 238, 217, 219, 154, 19, 48, 191, 229, 225, 50, 192, 52, 134, 185, 195, 78, 89, 116, 139, 242>>)

ietf_encrypt(M, AD, NPub, K)

:libsodium_crypto_aead_chacha20poly1305.ietf_decrypt(<<159, 176, 27, 214, 139, 57, 86, 55, 169, 141, 253, 253, 201, 85, 103, 205, 123, 111, 185>>, <<"321">>, <<185, 201, 166, 203, 130, 189, 171, 255, 243, 96, 77, 205>>, <<213, 87, 15, 192, 21, 200, 200, 142, 201, 31, 132, 120, 238, 217, 219, 154, 19, 48, 191, 229, 225, 50, 192, 52, 134, 185, 195, 78, 89, 116, 139, 242>>)

:ietf_decrypt(C, AD, NPub, K)

## Netcode.io design

Server key encrypts private connect token.

Generate two crypto secure random 32 bytes for the client to server and server to client key. 

Public and private data form a connect token.

Encrypted has associated data which is version info, protocol id and prefix byte.

Packets sent from client to server are encrypted with the client to server key in the connect token.

Packets sent from server to client are encrypted using the server to client key in the connect token for that client.