# docker-entrypoint.sh 常見寫法備註


```bash
### https://github.com/docker-library/redis/blob/7b37611579e91f4ce356dfc2954500b5d6d43b60/6.0/docker-entrypoint.sh
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
    set -- redis-server "$@"
fi
#
```
