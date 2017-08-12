defmodule AeadChacha20Poly1305Ietf do
  use Benchfella

  defp encrypt(bench_context) do
    :libsodium_crypto_aead_chacha20poly1305.ietf_encrypt(bench_context.message, bench_context.associated_data, bench_context.nounce, bench_context.key)
  end

  before_each_bench _ do
    data = %{nounce: :crypto.strong_rand_bytes(:libsodium_crypto_aead_chacha20poly1305.ietf_npubbytes()),
    key: :crypto.strong_rand_bytes(:libsodium_crypto_aead_chacha20poly1305.ietf_keybytes()),
    message: <<"123">>,
    associated_data: <<"321">>}
    {:ok, data}
  end

  bench "libsodium aeadchacha20poly1305 ietf decrypt", [encrypted: encrypt(bench_context) ]do
    # :ietf_decrypt(C, AD, NPub, K)
    :libsodium_crypto_aead_chacha20poly1305.ietf_decrypt(encrypted, bench_context.associated_data, bench_context.nounce, bench_context.key)
  end

  bench "libsodium aeadchacha20poly1305 ietf encrypt" do
    # ietf_encrypt(M, AD, NPub, K)
    encrypt(bench_context)
  end
end