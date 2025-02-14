# ExImapCodec

A small wrapper around the [imap-codec](https://github.com/duesee/imap-codec) rust library.

So far only the decoder has been implemented.

The result of the decode command is a struct with:
- the original input string in "original_command"
- the parsed command as a json string in "command"
- the arguments in "arguments" string
- the tag in "tag" string

## Installation

```elixir
def deps do
  [
    {:ex_imap_codec, "~> 0.1.0"}
  ]
end
```

## Example
```elixir
iex(1)> a = ExImapCodec.decode_imap_command "a login aaa bbb\r\n"
%{
  __struct__: ExImapCodec.CommandResult,
  arguments: %{},
  command_type: "{\n  \"Login\": {\n    \"username\": {\n      \"Atom\": \"aaa\"\n    },\n    \"password\": {\n      \"Atom\": \"bbb\"\n    }\n  }\n}",
  original_command: "a login aaa bbb\r\n",
  tag: "a"
}
iex(2)> str = "a002 SELECT INBOX\r\n"; ExImapCodec.decode_imap_command(str)
%{
  __struct__: ExImapCodec.CommandResult,
  arguments: %{},
  command_type: "{\n  \"Select\": {\n    \"mailbox\": \"Inbox\"\n  }\n}",
  original_command: "a002 SELECT INBOX\r\n",
  tag: "a002"
}
```
