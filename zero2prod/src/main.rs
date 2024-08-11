use zero2prod::run;
use std::net::TcpListener;

mod print_helpers;

#[tokio::main]
async fn main() -> Result<(), std::io::Error> {
    
    let listener = TcpListener::bind("127.0.0.1:0")
        .expect("Failed to bind random port");

    let port = listener.local_addr().unwrap().port();
    print_helpers::print_out(format!("Server started on port {}", port));

    run(listener)?.await
}