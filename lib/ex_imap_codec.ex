defmodule ExImapCodec do
  @moduledoc """
  Documentation for `ExImapCodec`.
  """
  use Rustler,
    otp_app: :ex_imap_codec,
    crate: :imap_codec_nif

  def decode_imap_command(_) do
    :erlang.nif_error(:nif_not_loaded)
  end
end
