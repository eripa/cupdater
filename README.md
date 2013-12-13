# cupdater #

A simple dynamic DNS updater for CloudFlare DNS. Run in cron (or similar), will check current IP and update the given subdomain to match.

## Requirements ##
 * CloudFlare gem: ```[sudo] gem install cloudflare```
 * Hope that akamai continues to provide their IP service http://whatismyip.akamai.com 

## How to use: ##
    ./cupdater.rb cloudflare_token clouflare_email domain subdomain
