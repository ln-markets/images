# fork-observer

Author: [0xB10C](https://github.com/0xB10C)

Source: https://github.com/0xB10C/fork-observer

## Example usage

```yaml
# compose.yml
version: "3.7"

services:
  fork-observer:
    image: lnmarkets/fork-observer:nightly
    restart: unless-stopped
    ports:
      - 8080:2323
    environment:
      DATA_PATH: /data
      CONFIG_FILE: /data/config.toml
    volumes:
      - fork-observer:/data
      - ./config.toml:/data/config.toml

volumes:
  fork-observer:
```

```toml
# config.toml (only the relevant parts for this example)
database_path = "/data/db"
www_path = "/srv/fork-observer/www"
address = "0.0.0.0:2323"
```
