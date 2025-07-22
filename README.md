# Wetterhaecker

## Setup

```bash
mix setup
```

## Start the application

```bash
iex -S mix phx.server
```

👉🏻 http://localhost:4000/

## Development

### Start Livebook

```bash
mix escript.install hex livebook
asdf reshim elixir
livebook server livebooks/wetterhaecker.livemd
```

### Start Brightsky API Mock

Start the application with alternative Brightsky Endpoint:

```bash
BRIGHTSKY_BASE_URL=http://127.0.0.1:4010 iex -S mix phx.server
```

After that, you need to start the Prism Mock server:

#### Using Docker

Start Prism Mock with Docker:

```bash
docker run --init --rm -v $(pwd):/tmp/wetterhaecker -p 4010:4010 stoplight/prism:4 mock -h 0.0.0.0 "/tmp/wetterhaecker/priv/static/brightsky_openapi.json"
```

#### Using Prism Mock CLI

[install prism mock cli](https://docs.stoplight.io/docs/prism/f51bcc80a02db-installation) and start the mock server:

```bash
prism mock priv/static/brightsky_openapi.json
```

## Type Generation for Brightsky Types

### Backend:

```bash
# download openapi.json via curl
curl -o priv/static/brightsky_openapi.json https://api.brightsky.dev/openapi.json
# generate types
mix api.gen brightsky priv/static/brightsky_openapi.json
```

### Frontend:

If you need to generate types for Brightsky, [install the openapicmd tool](https://openapistack.co/docs/openapicmd/intro/) and run:

```bash
openapi typegen https://api.brightsky.dev/openapi.json > assets/js/types/brightsky.d.ts
```
