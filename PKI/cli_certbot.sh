#!/bin/bash
exit 0
# ----------------------------------------------------

certbot --version
#certbot 1.3.0

### 刪除不要的域名
certbot delete
certbot delete --cert-name host.domain.com
#

### 直接驗證網域
MAIL=cool21540125@gmail.com
DOMAIN="*.tonychoucc.com"
certbot certonly --manual --agree-tos \
  -d ${DOMAIN} \
  --email ${MAIL} \
  --preferred-challenges dns \
  --manual-public-ip-logging-ok \
  --server https://acme-v02.api.letsencrypt.org/directory
# 接著不要急著按 Enter, 先到 DNS 加一筆 TXT record

###
certbot certonly -d "$DOMAIN" -d *."$DOMAIN"

###
certbot -h all
#usage:
#  certbot [SUBCOMMAND] [options] [-d DOMAIN] [-d DOMAIN] ...
#
#Certbot can obtain and install HTTPS/TLS/SSL certificates.  By default,
#it will attempt to use a webserver both for obtaining and installing the
#certificate. The most common SUBCOMMANDS and flags are:
#
#obtain, install, and renew certificates:
#    (default) run   Obtain & install a certificate in your current webserver
#    certonly        Obtain or renew a certificate, but do not install it             # 只作申請憑證. 不要安裝憑證到 Web Server(ex: 幫作 nginx.conf 相關配置)
#    renew           Renew all previously obtained certificates that are near expiry  # 重新更換先前 「已申請 && 即將到期」 的憑證
#    enhance         Add security enhancements to your existing configuration
#   -d DOMAINS       Comma-separated list of domains to obtain a certificate for
#
#  (the certbot apache plugin is not installed)
#  --standalone      Run a standalone webserver for authentication
#  --nginx           Use the Nginx plugin for authentication & installation
#  --webroot         Place files in a server''s webroot folder for authentication
#  --manual          Obtain certificates interactively, or using shell script hooks  # 互動式申請 或 藉由 --manual-auth-hook XXX.sh 處理 (Shell Script Hook)
#
#   -n               Run non-interactively
#  --test-cert       Obtain a test certificate from a staging server                     # 從 Staging Server 取得 test Certificate
#  --dry-run         Test "renew" or "certonly" without saving any certificates to disk  # (使用測試環境)嘗試做 renew + certonly, 但不儲存 Certificate
#  # 每個註冊域名的憑證頒發數量限制為每個星期 30000 張
#  # 重複憑證限制為每隔星期 30000 張
#  # 驗證失敗限制為每小時 60 次
#  # 註冊帳號限制為每個 IP 3 小時內能註冊 50 個帳號
#  # 使用 ACME v2，新請求限制為每個帳號 3 小時內 1500 個
#
#manage certificates:
#    certificates    Display information about certificates you have from Certbot
#    revoke          Revoke a certificate (supply --cert-name or --cert-path)
#    delete          Delete a certificate (supply --cert-name)
#
#manage your account:
#    register        Create an ACME account
#    unregister      Deactivate an ACME account
#    update_account  Update an ACME account
#  --agree-tos       Agree to the ACME server''s Subscriber Agreement
#   -m EMAIL         Email address for important account notifications
#
#optional arguments:
#  -h, --help            show this help message and exit
#  -c CONFIG_FILE, --config CONFIG_FILE
#                        path to config file (default: /etc/letsencrypt/cli.ini
#                        and ~/.config/letsencrypt/cli.ini)
#  -v, --verbose         This flag can be used multiple times to incrementally
#                        increase the verbosity of output, e.g. -vvv. (default:
#                        -2)
#  --max-log-backups MAX_LOG_BACKUPS
#                        Specifies the maximum number of backup logs that
#                        should be kept by Certbot''s built in log rotation.
#                        Setting this flag to 0 disables log rotation entirely,
#                        causing Certbot to always append to the same log file.
#                        (default: 1000)
#  -n, --non-interactive, --noninteractive  # 若要搭配 crontab, 就用這個來避免互動式詢問, 但若欠缺必要資訊, 仍會詢問
#                        Run without ever asking for user input. This may
#                        require additional command line flags; the client will
#                        try to explain which ones are required if it finds one
#                        missing (default: False)
#  --force-interactive   Force Certbot to be interactive even if it detects
#                        it''s not being run in a terminal. This flag cannot be
#                        used with the renew subcommand. (default: False)
#  -d DOMAIN, --domains DOMAIN, --domain DOMAIN
#                        Domain names to apply. For multiple domains you can
#                        use multiple -d flags or enter a comma separated list
#                        of domains as a parameter. The first domain provided
#                        will be the subject CN of the certificate, and all
#                        domains will be Subject Alternative Names on the
#                        certificate. The first domain will also be used in
#                        some software user interfaces and as the file paths
#                        for the certificate and related material unless
#                        otherwise specified or you already have a certificate
#                        with the same name. In the case of a name collision it
#                        will append a number like 0001 to the file path name.
#                        (default: Ask)
#  --eab-kid EAB_KID     Key Identifier for External Account Binding (default:
#                        None)
#  --eab-hmac-key EAB_HMAC_KEY
#                        HMAC key for External Account Binding (default: None)
#  --cert-name CERTNAME  Certificate name to apply. This name is used by
#                        Certbot for housekeeping and in file paths; it doesn''t
#                        affect the content of the certificate itself. To see
#                        certificate names, run 'certbot certificates'. When
#                        creating a new certificate, specifies the new
#                        certificate''s name. (default: the first provided
#                        domain or the name of an existing certificate on your
#                        system for the same domains)
#  --dry-run             Perform a test run of the client, obtaining test
#                        (invalid) certificates but not saving them to disk.
#                        This can currently only be used with the 'certonly'
#                        and 'renew' subcommands. Note: Although --dry-run
#                        tries to avoid making any persistent changes on a
#                        system, it is not completely side-effect free: if used
#                        with webserver authenticator plugins like apache and
#                        nginx, it makes and then reverts temporary config
#                        changes in order to obtain test certificates, and
#                        reloads webservers to deploy and then roll back those
#                        changes. It also calls --pre-hook and --post-hook
#                        commands if they are defined because they may be
#                        necessary to accurately simulate renewal. --deploy-
#                        hook commands are not called. (default: False)
#  --debug-challenges    After setting up challenges, wait for user input
#                        before submitting to CA (default: False)
#  --preferred-challenges PREF_CHALLS  # ex: 「--preferred-challenges=http」
#                        A sorted, comma delimited list of the preferred
#                        challenge to use during authorization with the most
#                        preferred challenge listed first (Eg, "dns" or
#                        "http,dns"). Not all plugins support all challenges.
#                        See https://certbot.eff.org/docs/using.html#plugins
#                        for details. ACME Challenges are versioned, but if you
#                        pick "http" rather than "http-01", Certbot will select
#                        the latest version automatically. (default: [])
#  --user-agent USER_AGENT
#                        Set a custom user agent string for the client. User
#                        agent strings allow the CA to collect high level
#                        statistics about success rates by OS, plugin and use
#                        case, and to know when to deprecate support for past
#                        Python versions and flags. If you wish to hide this
#                        information from the Let''s Encrypt server, set this to
#                        "". (default: CertbotACMEClient/1.3.0 (certbot; Amazon
#                        Linux 2) Authenticator/XXX Installer/YYY (SUBCOMMAND;
#                        flags: FLAGS) Py/2.7.16). The flags encoded in the
#                        user agent are: --duplicate, --force-renew, --allow-
#                        subset-of-names, -n, and whether any hooks are set.
#  --user-agent-comment USER_AGENT_COMMENT
#                        Add a comment to the default user agent string. May be
#                        used when repackaging Certbot or calling it from
#                        another tool to allow additional statistical data to
#                        be collected. Ignored if --user-agent is set.
#                        (Example: Foo-Wrapper/1.0) (default: None)
#
#automation:
#  Flags for automating execution & other tweaks
#
#  --keep-until-expiring, --keep, --reinstall  # 與 --force-renewal 相反 (避免 REPL 詢問)
#                        If the requested certificate matches an existing
#                        certificate, always keep the existing one until it is
#                        due for renewal (for the 'run' subcommand this means
#                        reinstall the existing certificate). (default: Ask)
#  --expand              If an existing certificate is a strict subset of the
#                        requested names, always expand and replace it with the
#                        additional names. (default: Ask)
#  --version             show program''s version number and exit
#  --force-renewal, --renew-by-default  # 與 --keep-until-expiring 相反. 強制立即換新的憑證
#                        If a certificate already exists for the requested
#                        domains, renew it now, regardless of whether it is
#                        near expiry. (Often --keep-until-expiring is more
#                        appropriate). Also implies --expand. (default: False)
#  --renew-with-new-domains
#                        If a certificate already exists for the requested
#                        certificate name but does not match the requested
#                        domains, renew it now, regardless of whether it is
#                        near expiry. (default: False)
#  --reuse-key           When renewing, use the same private key as the
#                        existing certificate. (default: False)
#  --allow-subset-of-names
#                        When performing domain validation, do not consider it
#                        a failure if authorizations can not be obtained for a
#                        strict subset of the requested domains. This may be
#                        useful for allowing renewals for multiple domains to
#                        succeed even if some domains no longer point at this
#                        system. This option cannot be used with --csr.
#                        (default: False)
#  --agree-tos           Agree to the ACME Subscriber Agreement (default: Ask)  # 直接同意 ACME 的一些條款 (避免 REPL 詢問)
#  --duplicate           Allow making a certificate lineage that duplicates an
#                        existing one (both can be renewed in parallel)
#                        (default: False)
#  --os-packages-only    (certbot-auto only) install OS package dependencies
#                        and then stop (default: False)
#  --no-self-upgrade     (certbot-auto only) prevent the certbot-auto script
#                        from upgrading itself to newer released versions
#                        (default: Upgrade automatically)
#  --no-bootstrap        (certbot-auto only) prevent the certbot-auto script
#                        from installing OS-level dependencies (default: Prompt
#                        to install OS-wide dependencies, but exit if the user
#                        says 'No')
#  --no-permissions-check
#                        (certbot-auto only) skip the check on the file system
#                        permissions of the certbot-auto script (default:
#                        False)
#  -q, --quiet           Silence all output except errors. Useful for
#                        automation via cron. Implies --non-interactive.
#                        (default: False)
#
#security:
#  Security parameters & server settings
#
#  --rsa-key-size N      Size of the RSA key. (default: 2048)
#  --must-staple         Adds the OCSP Must Staple extension to the
#                        certificate. Autoconfigures OCSP Stapling for
#                        supported setups (Apache version >= 2.3.3 ). (default:
#                        False)
#  --redirect            Automatically redirect all HTTP traffic to HTTPS for
#                        the newly authenticated vhost. (default: Ask)
#  --no-redirect         Do not automatically redirect all HTTP traffic to
#                        HTTPS for the newly authenticated vhost. (default:
#                        Ask)
#  --hsts                Add the Strict-Transport-Security header to every HTTP
#                        response. Forcing browser to always use SSL for the
#                        domain. Defends against SSL Stripping. (default: None)
#  --uir                 Add the "Content-Security-Policy: upgrade-insecure-
#                        requests" header to every HTTP response. Forcing the
#                        browser to use https:// for every http:// resource.
#                        (default: None)
#  --staple-ocsp         Enables OCSP Stapling. A valid OCSP response is
#                        stapled to the certificate that the server offers
#                        during TLS. (default: None)
#  --strict-permissions  Require that all configuration files are owned by the
#                        current user; only needed if your config is somewhere
#                        unsafe like /tmp/ (default: False)
#  --auto-hsts           Gradually increasing max-age value for HTTP Strict
#                        Transport Security security header (default: False)
#
#testing:
#  The following flags are meant for testing and integration purposes only.
#
#  --test-cert, --staging
#                        Use the staging server to obtain or revoke test
#                        (invalid) certificates; equivalent to --server https
#                        ://acme-staging-v02.api.letsencrypt.org/directory
#                        (default: False)
#  --debug               Show tracebacks in case of errors, and allow certbot-
#                        auto execution on experimental platforms (default:
#                        False)
#  --no-verify-ssl       Disable verification of the ACME server''s certificate.
#                        (default: False)
#  --http-01-port HTTP01_PORT
#                        Port used in the http-01 challenge. This only affects
#                        the port Certbot listens on. A conforming ACME server
#                        will still attempt to connect on port 80. (default:
#                        80)
#  --http-01-address HTTP01_ADDRESS
#                        The address the server listens to during http-01
#                        challenge. (default: )
#  --https-port HTTPS_PORT
#                        Port used to serve HTTPS. This affects which port
#                        Nginx will listen on after a LE certificate is
#                        installed. (default: 443)
#  --break-my-certs      Be willing to replace or renew valid certificates with
#                        invalid (testing/staging) certificates (default:
#                        False)
#
#paths:
#  Flags for changing execution paths & servers
#
#  --cert-path CERT_PATH
#                        Path to where certificate is saved (with auth --csr),
#                        installed from, or revoked. (default: None)
#  --key-path KEY_PATH   Path to private key for certificate installation or
#                        revocation (if account key is missing) (default: None)
#  --fullchain-path FULLCHAIN_PATH
#                        Accompanying path to a full certificate chain
#                        (certificate plus chain). (default: None)
#  --chain-path CHAIN_PATH
#                        Accompanying path to a certificate chain. (default:
#                        None)
#  --config-dir CONFIG_DIR
#                        Configuration directory. (default: /etc/letsencrypt)
#  --work-dir WORK_DIR   Working directory. (default: /var/lib/letsencrypt)
#  --logs-dir LOGS_DIR   Logs directory. (default: /var/log/letsencrypt)
#  --server SERVER       ACME Directory Resource URI. (default:
#                        https://acme-v02.api.letsencrypt.org/directory)
#
#manage:
#  Various subcommands and flags are available for managing your
#  certificates:
#
#  certificates          List certificates managed by Certbot
#  delete                Clean up all files related to a certificate
#  renew                 Renew all certificates (or one specified with --cert-
#                        name)
#  revoke                Revoke a certificate specified with --cert-path or
#                        --cert-name
#  update_symlinks       Recreate symlinks in your /etc/letsencrypt/live/
#                        directory
#
#run:
#  Options for obtaining & installing certificates
#
#certonly:
#  Options for modifying how a certificate is obtained
#
#  --csr CSR             Path to a Certificate Signing Request (CSR) in DER or
#                        PEM format. Currently --csr only works with the
#                        'certonly' subcommand. (default: None)
#
#renew:  # renew 過程中, 分為 5 個時間點, 分別對應到 5 個 hook, 而這 5 個 hook, 可以分為 2 組
#  The 'renew' subcommand will attempt to renew all certificates (or more
#  precisely, certificate lineages) you have previously obtained if they are
#  close to expiry, and print a summary of the results. By default, 'renew'
#  will reuse the options used to create obtain or most recently successfully
#  renew each certificate lineage. You can try it with `--dry-run` first. For
#  more fine-grained control, you can renew individual lineages with the
#  `certonly` subcommand. Hooks are available to run commands before and
#  after renewal; see https://certbot.eff.org/docs/using.html#renewal for
#  more information on these.
#  # renew 流程的第一組 hook 為 renew hook, 分別為底下接續的 3 個
#  --pre-hook PRE_HOOK   # 初始化 renew 前執行一次
#                        Command to be run in a shell before obtaining any
#                        certificates. Intended primarily for renewal, where it
#                        can be used to temporarily shut down a webserver that
#                        might conflict with the standalone plugin. This will
#                        only be called if a certificate is actually to be
#                        obtained/renewed. When renewing several certificates
#                        that have identical pre-hooks, only the first will be
#                        executed. (default: None)
#  --post-hook POST_HOOK  # 完成 renew 後執行一次
#                        Command to be run in a shell after attempting to
#                        obtain/renew certificates. Can be used to deploy
#                        renewed certificates, or to restart any servers that
#                        were stopped by --pre-hook. This is only run if an
#                        attempt was made to obtain/renew a certificate. If
#                        multiple renewed certificates have identical post-
#                        hooks, only one will be run. (default: None)
#  --deploy-hook DEPLOY_HOOK  # 每取得一個憑證, 就執行一次
#                        Command to be run in a shell once for each
#                        successfully issued certificate. For this command, the
#                        shell variable $RENEWED_LINEAGE will point to the
#                        config live subdirectory (for example,
#                        "/etc/letsencrypt/live/example.com") containing the
#                        new certificates and keys; the shell variable
#                        $RENEWED_DOMAINS will contain a space-delimited list
#                        of renewed certificate domains (for example,
#                        "example.com www.example.com" (default: None)
#  --disable-hook-validation
#                        Ordinarily the commands specified for --pre-hook
#                        /--post-hook/--deploy-hook will be checked for
#                        validity, to see if the programs being run are in the
#                        $PATH, so that mistakes can be caught early, even when
#                        the hooks aren''t being run just yet. The validation is
#                        rather simplistic and fails if you use more advanced
#                        shell constructs, so you can use this switch to
#                        disable it. (default: False)
#  --no-directory-hooks  Disable running executables found in Certbot''s hook
#                        directories during renewal. (default: False)
#  --disable-renew-updates
#                        Disable automatic updates to your server configuration
#                        that would otherwise be done by the selected installer
#                        plugin, and triggered when the user executes "certbot
#                        renew", regardless of if the certificate is renewed.
#                        This setting does not apply to important TLS
#                        configuration updates. (default: False)
#  --no-autorenew        Disable auto renewal of certificates. (default: True)
#
#certificates:
#  List certificates managed by Certbot
#
#delete:
#  Options for deleting a certificate
#
#revoke:
#  Options for revocation of certificates
#
#  --reason {unspecified,keycompromise,affiliationchanged,superseded,cessationofoperation}
#                        Specify reason for revoking certificate. (default:
#                        unspecified)
#  --delete-after-revoke
#                        Delete certificates after revoking them, along with
#                        all previous and later versions of those certificates.
#                        (default: None)
#  --no-delete-after-revoke
#                        Do not delete certificates after revoking them. This
#                        option should be used with caution because the 'renew'
#                        subcommand will attempt to renew undeleted revoked
#                        certificates. (default: None)
#
#register:
#  Options for account registration
#
#  --register-unsafely-without-email  # (強烈建議不要用這個) 不使用 email 來申請憑證 (將無法收到即將到期的告知 && 無法撤銷申請的憑證)
#                        Specifying this flag enables registering an account
#                        with no email address. This is strongly discouraged,
#                        because in the event of key loss or account compromise
#                        you will irrevocably lose access to your account. You
#                        will also be unable to receive notice about impending
#                        expiration or revocation of your certificates. Updates
#                        to the Subscriber Agreement will still affect you, and
#                        will be effective 14 days after posting an update to
#                        the web site. (default: False)
#  -m EMAIL, --email EMAIL
#                        Email used for registration and recovery contact. Use
#                        comma to register multiple emails, ex:
#                        u1@example.com,u2@example.com. (default: Ask).
#  --eff-email           Share your e-mail address with EFF (default: None)
#  --no-eff-email        Don''t share your e-mail address with EFF (default:
#                        None)
#
#update_account:
#  Options for account modification
#
#unregister:
#  Options for account deactivation.
#
#  --account ACCOUNT_ID  Account ID to use (default: None)
#
#install:
#  Options for modifying how a certificate is deployed
#
#rollback:  # ex: `certbot --nginx rollback`
#  Options for rolling back server configuration changes
#
#  --checkpoints N       Revert configuration N number of checkpoints.
#                        (default: 1)
#
#plugins:
#  Options for the "plugins" subcommand
#
#  --init                Initialize plugins. (default: False)
#  --prepare             Initialize and prepare plugins. (default: False)
#  --authenticators      Limit to authenticator plugins only. (default: None)
#  --installers          Limit to installer plugins only. (default: None)
#
#update_symlinks:
#  Recreates certificate and key symlinks in /etc/letsencrypt/live, if you
#  changed them by hand or edited a renewal configuration file
#
#enhance:
#  Helps to harden the TLS configuration by adding security enhancements to
#  already existing configuration.
#
#plugins:
#  Plugin Selection: Certbot client supports an extensible plugins
#  architecture. See 'certbot plugins' for a list of all installed plugins
#  and their names. You can force a particular plugin by setting options
#  provided below. Running --help <plugin_name> will list flags specific to
#  that plugin.
#
#  --configurator CONFIGURATOR
#                        Name of the plugin that is both an authenticator and
#                        an installer. Should not be used together with
#                        --authenticator or --installer. (default: Ask)
#  -a AUTHENTICATOR, --authenticator AUTHENTICATOR
#                        Authenticator plugin name. (default: None)
#  -i INSTALLER, --installer INSTALLER
#                        Installer plugin name (also used to find domains).
#                        (default: None)
#  --apache              Obtain and install certificates using Apache (default:
#                        False)
#  --nginx               Obtain and install certificates using Nginx (default:
#                        False)
#  --standalone          Obtain certificates using a "standalone" webserver.
#                        (default: False)
#  --manual              Provide laborious manual instructions for obtaining a
#                        certificate (default: False)
#  --webroot             Obtain certificates by placing files in a webroot
#                        directory. (default: False)
#  --dns-cloudflare      Obtain certificates using a DNS TXT record (if you are
#                        using Cloudflare for DNS). (default: False)
#  --dns-cloudxns        Obtain certificates using a DNS TXT record (if you are
#                        using CloudXNS for DNS). (default: False)
#  --dns-digitalocean    Obtain certificates using a DNS TXT record (if you are
#                        using DigitalOcean for DNS). (default: False)
#  --dns-dnsimple        Obtain certificates using a DNS TXT record (if you are
#                        using DNSimple for DNS). (default: False)
#  --dns-dnsmadeeasy     Obtain certificates using a DNS TXT record (if you are
#                        using DNS Made Easy for DNS). (default: False)
#  --dns-gehirn          Obtain certificates using a DNS TXT record (if you are
#                        using Gehirn Infrastructure Service for DNS).
#                        (default: False)
#  --dns-google          Obtain certificates using a DNS TXT record (if you are
#                        using Google Cloud DNS). (default: False)
#  --dns-linode          Obtain certificates using a DNS TXT record (if you are
#                        using Linode for DNS). (default: False)
#  --dns-luadns          Obtain certificates using a DNS TXT record (if you are
#                        using LuaDNS for DNS). (default: False)
#  --dns-nsone           Obtain certificates using a DNS TXT record (if you are
#                        using NS1 for DNS). (default: False)
#  --dns-ovh             Obtain certificates using a DNS TXT record (if you are
#                        using OVH for DNS). (default: False)
#  --dns-rfc2136         Obtain certificates using a DNS TXT record (if you are
#                        using BIND for DNS). (default: False)
#  --dns-route53         Obtain certificates using a DNS TXT record (if you are
#                        using Route53 for DNS). (default: False)
#  --dns-sakuracloud     Obtain certificates using a DNS TXT record (if you are
#                        using Sakura Cloud for DNS). (default: False)
#
#manual:  # renew 流程的第二組 hook 會搭配 manual 使用
#  Authenticate through manual configuration or custom shell scripts. When
#  using shell scripts, an authenticator script must be provided. The
#  environment variables available to this script depend on the type of
#  challenge. $CERTBOT_DOMAIN will always contain the domain being
#  authenticated. For HTTP-01 and DNS-01, $CERTBOT_VALIDATION is the
#  validation string, and $CERTBOT_TOKEN is the filename of the resource
#  requested when performing an HTTP-01 challenge. An additional cleanup
#  script can also be provided and can use the additional variable
#  $CERTBOT_AUTH_OUTPUT which contains the stdout output from the auth
#  script.
#
#  --manual-auth-hook MANUAL_AUTH_HOOK  # 驗證測試前
#                        Path or command to execute for the authentication  # 指定幫忙處理 ACME channenge (認證) 的腳本 (ex: 增加 TXT record)
#                        script (default: None)
#  --manual-cleanup-hook MANUAL_CLEANUP_HOOK  # 驗證測試後 (此與 --manual-auth-hook 搭配使用, ex: 清除 TXT record)
#                        Path or command to execute for the cleanup script
#                        (default: None)
#  --manual-public-ip-logging-ok  # (避免 REPL 詢問)
#                        Automatically allows public IP logging (default: Ask)
#
#nginx:
#  Nginx Web Server plugin
#
#  --nginx-server-root NGINX_SERVER_ROOT
#                        Nginx server root directory. (default: /etc/nginx)
#  --nginx-ctl NGINX_CTL
#                        Path to the 'nginx' binary, used for 'configtest' and
#                        retrieving nginx version number. (default: nginx)
#
#null:
#  Null Installer
#
#standalone:
#  Spin up a temporary webserver
#
#webroot:
#  Place files in webroot directory
#
#  --webroot-path WEBROOT_PATH, -w WEBROOT_PATH
#                        public_html / webroot path. This can be specified
#                        multiple times to handle different domains; each
#                        domain will have the webroot path that preceded it.
#                        For instance: `-w /var/www/example -d example.com -d
#                        www.example.com -w /var/www/thing -d thing.net -d
#                        m.thing.net` (default: Ask)
#  --webroot-map WEBROOT_MAP
#                        JSON dictionary mapping domains to webroot paths; this
#                        implies -d for each entry. You may need to escape this
#                        from your shell. E.g.: --webroot-map
#                        '{"eg1.is,m.eg1.is":"/www/eg1/", "eg2.is":"/www/eg2"}'
#                        This option is merged with, but takes precedence over,
#                        -w / -d entries. At present, if you put webroot-map in
#                        a config file, it needs to be on a single line, like:
#                        webroot-map = {"example.com":"/var/www"}. (default:
#                        {})
