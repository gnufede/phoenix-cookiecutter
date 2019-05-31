#!/bin/sh

sed -i'' -e 's/hostname: "localhost",/hostname: System.get_env("PG_HOST"),/' $1/config/dev.exs

sed -i'' -e 's/hostname: "localhost",/hostname: System.get_env("PG_HOST"),/' $1/config/test.exs

sed -i'' -e  's/password: "postgres",\n  database:/password: "postgres",\n  hostname: System.get_env("PG_HOST"),\n  database:/' $1/config/prod.secret.exs
