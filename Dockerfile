FROM elixir:latest as release

WORKDIR /
COPY . .

# required for mix release deps
RUN mix local.hex --force
RUN mix local.rebar --force
# release a production version
RUN MIX_ENV=prod mix release

# recopy to open new build files
FROM elixir:latest

COPY --from=release /_build/prod/rel/derailed .

CMD [ "/bin/derailed", "start" ]
