


# drone secret

```bash
### 製作 Drone Secrets
$# drone secret add --name ssh-tony-gce-key --data @${PATH_TO_PRIVATE_KEY}  --repository ${REPOSITORY/PROJECT}
$# drone secret add --name telegram_token --data ${TOKEN} --repository ${REPOSITORY/PROJECT}

### 查看 Drone Secrets
$# drone secret ls ${REPOSITORY/PROJECT}
tg_notify_group_id 
Pull Request Read:  false
Pull Request Write: false
# 怪了.... 上面這個是 Drone Web 看到的
```