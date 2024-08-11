use std::io::prelude::*;                                                           
use std::io;    

pub fn print_out(message: String) {
    print!("{}\n", message);
    io::stdout().flush().ok().expect("Could not flush stdout");
}