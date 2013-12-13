#!/usr/bin/env ruby
#
# This is a simple script for running in cron (or similar) for checking and updating a subdomain
# on the CloudFlare DNS service. A dynamic DNS updater for CloudFlare DNS.
#
# Author: Eric Ripa - eric@ripa.io (2013-12-13)

require 'cloudflare'
require 'open-uri'

abort("Please provide proper arguments, like this: #{__FILE__} cloudflare_token clouflare_email domain subdomain") if ARGV.length != 4

cloudflare_token = ARGV[0]
clouflare_email = ARGV[1]
subdomain = ARGV[2]
domain = ARGV[3]

cf = CloudFlare.new(cloudflare_token, clouflare_email)
all_subdomains = cf.rec_load_all domain
sub_domain_details = all_subdomains['response']['recs']['objs'].select { |d| d['display_name'] == subdomain }

abort("Error finding subdomain #{subdomain}") if sub_domain_details.first.nil?

current_ip = remote_ip = open('http://whatismyip.akamai.com').read
stored_ip = sub_domain_details.first['content']
record_id = sub_domain_details.first['rec_id']

unless current_ip == stored_ip
  output = cf.rec_edit(domain, 'A', record_id, subdomain, current_ip, 1)
  print "Incorrect IP for #{subdomain}.#{domain}. Current stored IP: #{stored_ip} Will update to: #{current_ip}.. "
  if output['result'] == 'success'
      puts 'Successfuly updated DNS record'
  else
      abort(output['msg']) # error message
  end
end

