use std::net::TcpListener;
use sqlx::{Connection, PgConnection, PgPool};
use zero2prod::configuration::get_configuration;
use zero2prod::startup::run;
use zero2prod::print_helpers::print_out;

#[tokio::main]
async fn main() -> Result<(), std::io::Error> {
    
    let configuration = get_configuration().expect("Failed to read configuration.");
    let connection_pool = PgPool::connect(
            &configuration.database.connection_string()
        )
        .await
        .expect("Failed to connect to Postgres.");
        

    let address = format!("127.0.0.1:{}", configuration.application_port);

    let listener = TcpListener::bind(address)
        .expect("Failed to bind random port");

    let port = listener.local_addr().unwrap().port();
    print_out(format!("Server started on port {}", port));

    run(listener, connection_pool)?.await
}