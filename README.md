# 2dots

## Project Setup

1. Ensure, that you have the code from backend and frontent repositories cloned
2. Install docker, using [this guide](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04).
3. Install docker-compose, using [this guide](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-18-04).
4. Inside the `backend`-folder, create the file named `.env` and copy the contents from `.env.example` into it.
5. Using terminal, `cd` into project directory and run `docker-compose up --build`.
6. Once the build is done and the project is running - create the DataBase and run the migrations, using the following commands: `docker exec -it tds_backend_1 rails db:create` and `docker exec -it tds_backend_1 rails db:migrate`.
7. Update ElasticSearch indexes by running `docker exec -it tds_backend_1 rails searchkick:reindex:all`
8. You should have the project running.

## Database import (Assuming, you have the file)
1. Copy your DB dump into mounted folder (`/mnt/tds/db/postgres`)
2. Stop the project if it's running (`docker-compose down`)
3. Launch the database service on it's own (`docker-compose run database`)
4. In a different terminal - connect to PostgreSQL console using this command `docker exec -it tds_database_run_1 psql -U postgres` (If it asks for a password - the development pass should be `secret`)
5. In psql-console - Remove the existing database `DROP DATABASE "tds-backend_development";`, then run `CREATE DATABASE "tds-backend_development";` and exit the console.
6. Stop the database service (Got to a terminal tab, where you've launced `docker-compose run database` and stop it with `CTRL+C`).
7. Start the docker-compose as usual `docker-compose up`.
8. Get inside the database container `docker exec -it tds_database_1 bash` and go to data-directory `cd /var/lib/postgresql/data`
9. Inside the data directory run `pg_restore`-script (`pg_restore -U postgres -d tds-backend_development < oct_17.sql`)
10. Run the database migration to prevent "Pending Migration Error" in Rails API (`docker exec -it tds_backend_1 rails db:migrate`).
11. *(OPTIONAL)* Configure a superadmin user access in Rails
    - Go to rails console `docker exec -it tds_backend_1 rails c`
    - run `User.where(admin: true, super_user: true).first.update(email: 'admin@admin.com', password: '1q2w3e4r')`
    - login with credentials above
