
# 參考

- [acme notify 用法](https://github.com/acmesh-official/acme.sh/wiki/notify)
- 


# acme.sh notify

```bash
### 首次使用須設定
./acme.sh --set-notify \
    --notify-hook telegram \
    --notify-level 2 \
    --notify-mode 0
```


# acme.sh Help

```bash
https://github.com/acmesh-official/acme.sh
v3.0.0
Usage: acme.sh <command> ... [parameters ...]
Commands:
  -h, --help               Show this help message.
  -v, --version            Show version info.
  --install                Install acme.sh to your system.
  --uninstall              Uninstall acme.sh, and uninstall the cron job.
  --upgrade                Upgrade acme.sh to the latest code from https://github.com/acmesh-official/acme.sh.
  --issue                  Issue a cert.
  --deploy                 Deploy the cert to your server.
  -i, --install-cert       Install the issued cert to apache/nginx or any other server.
  -r, --renew              Renew a cert.
  --renew-all              Renew all the certs.
  --revoke                 Revoke a cert.
  --remove                 Remove the cert from list of certs known to acme.sh.
  --list                   List all the certs.  ## 可以列出用 acme.sh 生成了幾張證書了(多域名證書只算一份)
  --to-pkcs12              Export the certificate and key to a pfx file.
  --to-pkcs8               Convert to pkcs8 format.
  --sign-csr               Issue a cert from an existing csr.
  --show-csr               Show the content of a csr.
  -ccr, --create-csr       Create CSR, professional use.
  --create-domain-key      Create an domain private key, professional use.
  --update-account         Update account info.
  --register-account       Register account key.
  --deactivate-account     Deactivate the account.
  --create-account-key     Create an account private key, professional use.
  --install-cronjob        Install the cron job to renew certs, you don\'t need to call this. The 'install' command can automatically install the cron job.
  --uninstall-cronjob      Uninstall the cron job. The 'uninstall' command can do this automatically.
  --cron                   Run cron job to renew all the certs.
  --set-notify             Set the cron notification hook, level or mode.
  --deactivate             Deactivate the domain authz, professional use.
  --set-default-ca         Used with '--server', Set the default CA to use.
                           See: https://github.com/acmesh-official/acme.sh/wiki/Server


Parameters:
  -d, --domain <domain.tld>         Specifies a domain, used to issue, renew or revoke etc.
  --challenge-alias <domain.tld>    The challenge domain alias for DNS alias mode.
                                    See: https://github.com/acmesh-official/acme.sh/wiki/DNS-alias-mode

  --domain-alias <domain.tld>       The domain alias for DNS alias mode.
                                    See: https://github.com/acmesh-official/acme.sh/wiki/DNS-alias-mode

  --preferred-chain <chain>         If the CA offers multiple certificate chains, prefer the chain with an issuer matching this Subject Common Name.
                                    If no match, the default offered chain will be used. (default: empty)
                                    See: https://github.com/acmesh-official/acme.sh/wiki/Preferred-Chain

  -f, --force                       Force install, force cert renewal or override sudo restrictions.
  --staging, --test                 Use staging server, for testing.
  --debug [0|1|2|3]                 Output debug info. Defaults to 1 if argument is omitted.
  --output-insecure                 Output all the sensitive messages.
                                    By default all the credentials/sensitive messages are hidden from the output/debug/log for security.
  -w, --webroot <directory>         Specifies the web root folder for web root mode.
  --standalone                      Use standalone mode.
  --alpn                            Use standalone alpn mode.
  --stateless                       Use stateless mode.
                                    See: https://github.com/acmesh-official/acme.sh/wiki/Stateless-Mode

  --apache                          Use apache mode.
  --dns [dns_hook]                  Use dns manual mode or dns api. Defaults to manual mode when argument is omitted.
                                    See: https://github.com/acmesh-official/acme.sh/wiki/dnsapi

  --dnssleep <seconds>              The time in seconds to wait for all the txt records to propagate in dns api mode.
                                    It\'s not necessary to use this by default, acme.sh polls dns status by DOH automatically.
  -k, --keylength <bits>            Specifies the domain key length: 2048, 3072, 4096, 8192 or ec-256, ec-384, ec-521.
  -ak, --accountkeylength <bits>    Specifies the account key length: 2048, 3072, 4096
  --log [file]                      Specifies the log file. Defaults to "/root/.acme.sh/acme.sh.log" if argument is omitted.
  --log-level <1|2>                 Specifies the log level, default is 1.
  --syslog <0|3|6|7>                Syslog level, 0: disable syslog, 3: error, 6: info, 7: debug.
  --eab-kid <eab_key_id>            Key Identifier for External Account Binding.
  --eab-hmac-key <eab_hmac_key>     HMAC key for External Account Binding.


  These parameters are to install the cert to nginx/apache or any other server after issue/renew a cert:

  --cert-file <file>                Path to copy the cert file to after issue/renew..
  --key-file <file>                 Path to copy the key file to after issue/renew.
  --ca-file <file>                  Path to copy the intermediate cert file to after issue/renew.
  --fullchain-file <file>           Path to copy the fullchain cert file to after issue/renew.
  --reloadcmd <command>             Command to execute after issue/renew to reload the server.

  --server <server_uri>             ACME Directory Resource URI. (default: https://acme.zerossl.com/v2/DV90)
                                    See: https://github.com/acmesh-official/acme.sh/wiki/Server

  --accountconf <file>              Specifies a customized account config file.  ## 自訂的 account.conf 路徑
  --home <directory>                Specifies the home dir for acme.sh.          ## 變更證書生好後預設放置位置
  --cert-home <directory>           Specifies the home dir to save all the certs, only valid for '--install' command.
  --config-home <directory>         Specifies the home dir to save all the configurations.  ## config home
  --useragent <string>              Specifies the user agent string. it will be saved for future use too.
  -m, --email <email>               Specifies the account email, only valid for the '--install' and '--update-account' command.
  --accountkey <file>               Specifies the account key path, only valid for the '--install' command.
  --days <ndays>                    Specifies the days to renew the cert when using '--issue' command. The default value is 60 days.
  --httpport <port>                 Specifies the standalone listening port. Only valid if the server is behind a reverse proxy or load balancer.
  --tlsport <port>                  Specifies the standalone tls listening port. Only valid if the server is behind a reverse proxy or load balancer.
  --local-address <ip>              Specifies the standalone/tls server listening address, in case you have multiple ip addresses.
  --listraw                         Only used for '--list' command, list the certs in raw format.
  -se, --stop-renew-on-error        Only valid for '--renew-all' command. Stop if one cert has error in renewal.
  --insecure                        Do not check the server certificate, in some devices, the api server\'s certificate may not be trusted.
  --ca-bundle <file>                Specifies the path to the CA certificate bundle to verify api server\'s certificate.
  --ca-path <directory>             Specifies directory containing CA certificates in PEM format, used by wget or curl.
  --no-cron                         Only valid for '--install' command, which means: do not install the default cron job.
                                    In this case, the certs will not be renewed automatically.
  --no-profile                      Only valid for '--install' command, which means: do not install aliases to user profile.
  --no-color                        Do not output color text.
  --force-color                     Force output of color text. Useful for non-interactive use with the aha tool for HTML E-Mails.
  --ecc                             Specifies to use the ECC cert. Valid for '--install-cert', '--renew', '--revoke', '--to-pkcs12' and '--create-csr'
  --csr <file>                      Specifies the input csr.
  --pre-hook <command>              Command to be run before obtaining any certificates.
  --post-hook <command>             Command to be run after attempting to obtain/renew certificates. Runs regardless of whether obtain/renew succeeded or failed.
  --renew-hook <command>            Command to be run after each successfully renewed certificate.
  --deploy-hook <hookname>          The hook file to deploy cert  ## 每執行完一次證書生成, 就執行一次(可搭配此選項, 將證書部署到 Server)
  --ocsp, --ocsp-must-staple        Generate OCSP-Must-Staple extension.
  --always-force-new-domain-key     Generate new domain key on renewal. Otherwise, the domain key is not changed by default.
  --auto-upgrade [0|1]              Valid for '--upgrade' command, indicating whether to upgrade automatically in future. Defaults to 1 if argument is omitted.
  --listen-v4                       Force standalone/tls server to listen at ipv4.
  --listen-v6                       Force standalone/tls server to listen at ipv6.
  --openssl-bin <file>              Specifies a custom openssl bin location.
  --use-wget                        Force to use wget, if you have both curl and wget installed.
  --yes-I-know-dns-manual-mode-enough-go-ahead-please  Force use of dns manual mode.
                                    See:  https://github.com/acmesh-official/acme.sh/wiki/dns-manual-mode

  -b, --branch <branch>             Only valid for '--upgrade' command, specifies the branch name to upgrade to.
  --notify-level <0|1|2|3>          Set the notification level:  Default value is 2.
                                    0: disabled, no notification will be sent.                                        ## Disable
                                    1: send notifications only when there is an error.                                ## Error Level
                                    2: send notifications when a cert is successfully renewed, or there is an error.  ## Notice Level (default)
                                    3: send notifications when a cert is skipped, renewed, or error.                  ## Debug Level
  --notify-mode <0|1>               Set notification mode. Default value is 0.  ## 如果一次申請一整批, 用這個訊息比較乾淨些...
                                    0: Bulk mode. Send all the domain\'s notifications in one message(mail).
                                    1: Cert mode. Send a message for every single cert.
  --notify-hook <hookname>          Set the notify hook
  --revoke-reason <0-10>            The reason for revocation, can be used in conjunction with the '--revoke' command.
                                    See: https://github.com/acmesh-official/acme.sh/wiki/revokecert

  --password <password>             Add a password to exported pfx file. Use with --to-pkcs12.
```