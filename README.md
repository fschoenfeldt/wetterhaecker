# Wetterhaecker

Wetterhacker is a tool that imports .gpx files, for example for hiking or cycling and displays the weather data for the route. It uses the [Brightsky API](http://brightsky.dev/) to fetch weather data and is built with [Phoenix Framework](https://www.phoenixframework.org/). Because of Brightsky, only german locations are supported at the moment.

**live demo at: https://fschoenf.uber.space/wetterhaecker**

## Development

1. Install requirements (see `.tool-versions`):

   - asdf
   - Elixir
   - Erlang
   - Node.js

2. Run Setup:

   - ```bash
     mix setup
     ```

3. Start application:

   - ```bash
     iex -S mix phx.server
     ```
   - 👉🏻 http://localhost:4000/wetterhaecker

### Livebook

Livebook is used to try out different backend contexts interactively.

```bash
mix escript.install hex livebook
asdf reshim elixir
livebook server livebooks/wetterhaecker.livemd
```

### Weather Data Mock

By default, the application uses [the real Brightsky API](http://brightsky.dev/) for weather data. To use a mock server instead, you need to do the following steps:

1. Start Prism Mock Server

   1. using Docker

      - ```bash
        docker run --init --rm -v $(pwd):/tmp/wetterhaecker -p 4010:4010 stoplight/prism:4 mock -h 0.0.0.0 "/tmp/wetterhaecker/priv/static/brightsky_openapi.json"
        ```

   2. using [Prism Mock CLI](https://docs.stoplight.io/docs/prism/f51bcc80a02db-installation)
      - ```bash
        prism mock priv/static/brightsky_openapi.json
        ```

2. Set the `BRIGHTSKY_BASE_URL` environment variable to point to the mock server and start the application:
   - ```bash
     BRIGHTSKY_BASE_URL=http://127.0.0.1:4010 iex -S mix phx.server
     ```

### Type Generation for Brightsky Types

#### Backend:

```bash
# download openapi.json via curl
curl -o priv/static/brightsky_openapi.json https://api.brightsky.dev/openapi.json
# generate types
mix api.gen brightsky priv/static/brightsky_openapi.json
```

#### Frontend:

If you need to generate types for Brightsky, [install the openapicmd tool](https://openapistack.co/docs/openapicmd/intro/) and run:

```bash
openapi typegen https://api.brightsky.dev/openapi.json > assets/js/types/brightsky.d.ts
```

## Production

### Hosting on [Uberspace](https://uberspace.de)

1. copy `.envrc.example` to `.envrc.local` and adjust the values.
2. copy `./bin/wetterhaecker.ini.example` to `./bin/wetterhaecker.ini` and adjust the values.
3. run `./bin/deploy.sh` to deploy the application to your Uberspace server.

After first deployment, you need to [open a web backend on uberspace](https://manual.uberspace.de/web-backends/#specific-path).

### Building a Release using Docker

There's a `Dockerfile` in the root of the project that can be used to build a production image of the application. Note that you need to have a server with the [same OS, version and architecture as the one you build the image on](https://hexdocs.pm/phoenix/releases.html).

```bash
docker buildx build --build-arg BUILDKIT_MULTI_PLATFORM=1 --platform linux/amd64 --target release-export --output type=local,dest=./rel .
```
