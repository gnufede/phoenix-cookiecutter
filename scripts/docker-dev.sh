#!/usr/bin/env bash
mix ecto.migrate || mix ecto.create && mix ecto.migrate  # migrate your database if Ecto is used
mix phx.server
