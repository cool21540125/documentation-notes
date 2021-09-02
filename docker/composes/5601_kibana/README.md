

```bash
docker run -d \
    --name kib \
    --net elk \
    -p 5601:5601 \
    -e "ELASTICSEARCH_HOSTS=http://es01-test:9200" \
    kibana:7.14
```