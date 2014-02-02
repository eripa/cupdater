#!/usr/bin/env ruby
#
# This is a simple script for running in cron (or similar) for checking and updating a subdomain
# on the CloudFlare DNS service. A dynamic DNS updater for CloudFlare DNS.
#
# Author: Eric Ripa - eric@ripa.io (2013-12-13)

require 'cloudflare'
require 'open-uri'

if ARGV.include? "-verbose"
  # Enable verbose_mode, else be quiet
  verbose_mode = true
  ARGV.delete("-verbose")
else
  verbose_mode = false
end

abort("Please provide proper arguments, like this: #{__FILE__} cloudflare_token clouflare_email domain subdomain") if ARGV.length != 4

cloudflare_token = ARGV[0]
clouflare_email = ARGV[1]
subdomain = ARGV[2]
domain = ARGV[3]


begin
  cf = CloudFlare.new(cloudflare_token, clouflare_email)
  all_subdomains = cf.rec_load_all domain
  sub_domain_details = all_subdomains['response']['recs']['objs'].select { |d| d['display_name'] == subdomain }
rescue Exception => e
  if verbose_mode
    abort("Encountered and error during CloudFlare API Call. Error was #{e}")
  else
    abort()
  end
end

if verbose_mode
  abort("Error finding subdomain #{subdomain}") if sub_domain_details.first.nil?
else
  abort
end

current_ip = remote_ip = open('http://whatismyip.akamai.com').read
stored_ip = sub_domain_details.first['content']
record_id = sub_domain_details.first['rec_id']

unless current_ip == stored_ip
  output = cf.rec_edit(domain, 'A', record_id, subdomain, current_ip, 1)
  print "Incorrect IP for #{subdomain}.#{domain}. Current stored IP: #{stored_ip} Will update to: #{current_ip}.. "
  if output['result'] == 'success' and verbose_mode
      puts 'Successfuly updated DNS record'
  else
    if verbose_mode
      abort(output['msg']) # error message
    else
      abort
    end
  end
end

