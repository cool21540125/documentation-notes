# DS220+

## Install acme.sh

- 2021/05/29
- [Synology NAS With Free SSL Certificate on a Private Domain](https://itnext.io/synology-lets-encrypt-dns-01-challenge-acme-sh-and-route53-af491786d262)

```bash
wget https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh

sh ./acme.sh --install --nocron --home /volume1/homes/admin/acme
# 會跳出警告, 但不用鳥他

mkdir /volume1/homes/admin/acme/dnsapi && \
    cd /volume1/homes/admin/acme/dnsapi

# Case - Cloudflare
wget https://raw.githubusercontent.com/Neilpang/acme.sh/master/dnsapi/dns_cf.sh

# Case - AWS R53
wget https://raw.githubusercontent.com/Neilpang/acme.sh/master/dnsapi/dns_aws.sh
```