use imap_codec::{decode::Decoder, CommandCodec};
use imap_types::command::CommandBody;
use rustler::{NifStruct, Term, Env, Encoder};
use imap_types::IntoStatic;

macro_rules! make_map {
    ($env:expr, { $($key:expr => $value:expr),* $(,)? }) => {{
        let mut map = Term::map_new($env);
        $(
            map = map.map_put(
                $key.encode($env),
                $value.encode($env)
            ).unwrap();
        )*
        map
    }};
}

#[derive(NifStruct)]
#[module = "ExImapCodec.CommandResult"]
pub struct CommandResult<'a> {
    pub tag: String,
    pub command_type: String,
    pub arguments: Term<'a>,
}

#[rustler::nif]
fn decode_imap_command<'a>(env: Env<'a>, input: &str) -> Result<CommandResult<'a>, rustler::Error> {
    let codec = CommandCodec::new();

    match codec.decode(input.as_bytes()) {
        Ok((_binary_data, command)) => {
            let tag = format!("{:?}", command.tag.into_static());

            let (command_type, arguments) = match command.body {
                CommandBody::Login { username, password } => (
                    "LOGIN".to_string(),
                    make_map!(env, {
                        "username" => format!("{:?}", username),
                        "password" => format!("{:#?}", password)
                    }),
                ),
                // CommandBody::Select { mailbox } => (
                //     "SELECT".to_string(),
                //     make_map!(env, {
                //         "mailbox" => mailbox.to_string()
                //     }),
                // ),
                // CommandBody::List { reference, mailbox_wildcard, .. } => (
                //     "LIST".to_string(),
                //     make_map!(env, {
                //         "reference" => reference.to_string(),
                //         "mailbox" => mailbox_wildcard.to_string()
                //     }),
                // ),
                // CommandBody::Fetch { sequence, items } => (
                //     "FETCH".to_string(),
                //     make_map!(env, {
                //         "sequence" => sequence.to_string(),
                //         "items" => format!("{:?}", items)
                //     }),
                // ),
                _ => (
                    format!("{:?}", command.body),
                    make_map!(env, {})
                ),
            };

            Ok(CommandResult {
                tag,
                command_type,
                arguments,
            })
        }
        Err(err) => Err(rustler::Error::Term(Box::new(format!("Decode error: {:?}", err)))),
    }
}

rustler::init!("Elixir.ExImapCodec");
