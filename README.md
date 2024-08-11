# rust_zero_to_production

### IDE
This is a VS Code project.

### Installing Sqlx
* cargo install --version="~0.7" sqlx-cli --no-default-features --features rustls,postgres

### Creating Migrations
Run the following

* export DATABASE_URL=postgres://postgres:password@localhost:5432/newsletter
* sqlx migrate add create_subscriptions_table

You'll see a new file created in /migrations. Add your sql there.

### Running Migrations
Run the following

* export DATABASE_URL=postgres://postgres:password@localhost:5432/newsletter
* sqlx migrate run

You should see output like "Applied ..."

### Storage Tools
Install the following VS Code extensions
* Extension = SQLTools (https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools)
* Drivers = SQLTools PostgreSQL/Cockroach Driver (https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools-driver-pg)