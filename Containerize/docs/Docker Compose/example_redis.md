# [Get started with Docker Compose](https://docs.docker.com/compose/gettingstarted/)

- 2019/07/22

```bash
$ mkdir composetest
$ cd composetest
```

```python
### app.py
import time
import redis
from flask import Flask

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)

def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)

@app.route('/')
def hello():
    count = get_hit_count()
        return 'Hello! Its the {} times'.format(count)
```

```bash
### requirements.txt
flask
redis
```

```dockerfile
### Dockerfile
FROM        python:3.7-alpine
WORKDIR     /code
ENV         FLASK_APP app.py
ENV         FLASK_RUN_HOST  0.0.0.0
# Install gcc so Python packages such as MarkupSafe and SQLAlchemy can compile speedups.
RUN         apk add --no-cache gcc musl-dev linux-headers
COPY        . .
RUN         pip install -r requirements.txt
CMD         ["flask run"]
```

```yml
### docker-compose.yml
version: '3'
services:
    web:
        build: .
        ports:
            - "5000:5000"
        volumes:
            - .:/code
        environment:
            FLASK_ENV: development
    redis:
        image: "redis:alpine"
```

