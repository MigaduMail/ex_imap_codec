use imap_codec::{decode::Decoder, CommandCodec};
use rustler::{NifStruct, Term, Env};

macro_rules! make_map {
    ($env:expr, { $($key:expr => $value:expr),* $(,)? }) => {{
        let map = Term::map_new($env);
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
    pub original_command: String,
    pub tag: String,
    pub command: String,
    pub arguments: Term<'a>,
}

#[rustler::nif]
fn decode_imap_command<'a>(env: Env<'a>, input: &str) -> Result<CommandResult<'a>, rustler::Error> {
    let codec = CommandCodec::new();

    match codec.decode(input.as_bytes()) {
        Ok((_binary_data, command)) => {
            let command_str = serde_json::to_string_pretty(&command.body).unwrap();
            let arguments_str = make_map!(env, {});
            // let arguments_str = serde_json::to_string_pretty(&env).unwrap();
            let tag_str = command.tag.inner().to_string();

            Ok(CommandResult {
                original_command: input.to_string(),
                tag: tag_str,
                command: command_str,
                arguments: arguments_str,
            })
        }
        Err(err) => Err(rustler::Error::Term(Box::new(format!("Decode error: {:?}", err)))),
    }
}

rustler::init!("Elixir.ExImapCodec");
