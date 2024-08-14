use actix_web::{ dev::Server, web, App, HttpServer };
use std::net::TcpListener;
use sqlx::{PgConnection, PgPool};

use crate::routes::*;

pub fn run(
    listener: TcpListener, 
    connection_pool: PgPool) 
    -> Result<Server, std::io::Error> {
    let connection_pool = web::Data::new(connection_pool);
    let server = HttpServer::new( move || {
        App::new()
            .route("/", web::get().to(greet))
            .route("/{name}", web::get().to(greet))
            .route("/health_check", web::get().to(health_check))
            .route("/subscriptions", web::post().to(subscribe))
            .app_data(connection_pool.clone())
    })
    .listen(listener)?
    .run();

    Ok(server)
}