use rustler::{NifResult};
use imap_codec::{decode::Decoder, CommandCodec};

#[rustler::nif]
fn decode_imap_command(input: &str) -> NifResult<String> {
    println!("{:?}", input);

    // let input = "ABCD UID FETCH 1,2:* (BODY.PEEK[1.2.3.4.MIME]<42.1337>)\r\n";
    let codec = CommandCodec::new();
    match codec.decode(input.as_bytes()) {
        Ok((_, command)) => {
            // Assuming Command has a method to convert it to a String, adjust as necessary
            let command_string = format!("{:?}", command); //command.to_string(); // Replace with actual conversion if needed
            println!("OK - #{}", command_string);
            println!("OK tag - #{:?}", command.tag);
            println!("OK body - #{:?}", command.body);
            Ok(command_string)
        },
        Err(e) => {
            // Convert CommandDecodeError to a string representation
            // let error_message = format!("{:?}", e); // Or use e.to_string() if implemented
            println!("Error - {:?}", e);

            Err(::rustler::Error::BadArg)
        },
    }
}


rustler::init!("Elixir.ExImapCodec");
