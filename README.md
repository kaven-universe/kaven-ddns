# Kaven-DDNS

A lightweight Dynamic DNS client built with .NET that:

- Detects your current public IPv4 address from multiple endpoints
- Optionally listens to router syslog for IP updates
- Sends local email notifications
- Updates DNS records automatically (AliDNS provider)

This project targets .NET 10.

## Features

- Periodic WAN IP checks with configurable interval
- Multiple fallback IP lookup endpoints
- Optional router syslog parsing with regex capture
- Local SMTP notification on IP change/inactive status
- Automatic DNS A-record update support for AliDNS
- Local IP cache file to detect changes efficiently

## Docker

Run with mounted configuration and log directories, and expose syslog UDP port `514`:

```sh
docker run -d \
    --name kaven-ddns \
    -v "$(pwd)/Configuration:/App/Configuration" \
    -v "$(pwd)/Log:/App/Log" \
    -p 514:514/udp \
    --restart unless-stopped \
    kaven-ddns:latest
```

Notes:

- Place your config file at `./Configuration/Kaven-DDNS.kcf` on the host.
- Container paths are fixed to `/App/Configuration` and `/App/Log`.
- If another service already uses UDP `514` on your host, change the host-side port (for example: `-p 1514:514/udp`).

## Configuration

Main config file example (Kaven-DDNS.kcf):

```json
{
    "Name": "DDnsClient",
    "PeriodicCheckInterval": "00:01:00",
    "EnableRouterSyslogCheck": true,
    "RouterSyslogAddress": "0.0.0.0",
    "RouterSyslogPort": 514,
    "RouterSyslogRegexes": [
        "local\\s+IP\\s+address\\s+(?<ip>\\d{1,3}(?:\\.\\d{1,3}){3})"
    ],
    "EndpointUrls": [
        "https://ip.kaven.xyz",
        "https://ifconfig.me/ip",
        "https://ipv4.icanhazip.com",
        "https://api.ipify.org"
    ],
    "HttpRequestTimeout": "00:00:10",
    "EnableLocalNotification": true,
    "LocalMailSetting": {
        "Enable": true,
        "Server": {
            "From": "Name <name@example.com>",
            "Host": "smtp.example.com",
            "Port": 465,
            "EnableSsl": true,
            "EnableAuthentication": true,
            "UserName": "smtp-username",
            "Password": "smtp-password"
        },
        "Recipient": {
            "To": ["admin@example.com"],
            "Cc": [],
            "Bcc": []
        }
    },
    "NotifyOnIpChanged": true,
    "NotifyOnInactive": true,
    "InactiveThreshold": "00:05:00",
    "EnableAutoUpdateDNSRecords": true,
    "DNSRecords": [
        {
            "Provider": "Ali",
            "Domains": [
                {
                    "Id": "123456",
                    "Type": "A",
                    "DomainName": "example.com",
                    "RR": "www"
                }
            ],
            "AccessKeyId": "your-access-key-id",
            "AccessKeySecret": "your-access-key-secret"
        }
    ],
    "IpFile": "ip.txt"
}
```

## Key Settings

- PeriodicCheckInterval: check cycle duration
- EndpointUrls: public IP API fallback list
- EnableRouterSyslogCheck: enable UDP syslog listener
- RouterSyslogRegexes: regex list; must capture IPv4 using named group ip
- EnableLocalNotification: toggle local email alerts
- NotifyOnIpChanged: send notification when WAN IP changes
- NotifyOnInactive: send notification when no update is observed
- EnableAutoUpdateDNSRecords: toggle DNS provider update
- DNSRecords: provider credentials and target records
- IpFile: local file path for last known IP

## License

Licensed under the terms in LICENSE.txt.
