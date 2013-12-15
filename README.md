# cupdater #

A simple dynamic DNS updater for CloudFlare DNS. Run in cron (or similar), will check current IP and update the given subdomain to match.

## How to use: ##
    ./cupdater.rb cloudflare_token clouflare_email domain subdomain

### launchd ###

If you want to run it in launchd instead of cron, edit the plist-template to match your setup and activate load it:

    launchctl load /path/to/cupdater/io.ripa.cupdater.plist
