# cupdater #

A simple dynamic DNS updater for CloudFlare DNS. Run in cron (or similar), will check current IP and update the given subdomain to match.

## Requirements ##

 * CloudFlare gem: ```[sudo] gem install cloudflare```
 * Hope that akamai continues to provide their IP service http://whatismyip.akamai.com
 * You will probably need to update the root certificates if you are on OS X. [Instructions](http://railsapps.github.io/openssl-certificate-verify-failed.html)

## How to use: ##

    ./cupdater.rb cloudflare_token clouflare_email domain subdomain

### launchd ###

If you want to run it in launchd instead of cron, edit the plist-template to match your setup and activate load it:

    launchctl load /path/to/cupdater/io.ripa.cupdater.plist

