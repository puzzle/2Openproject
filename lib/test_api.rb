#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'


uri = URI.parse('https://ticket-stg.puzzle.ch/api/v3/projects/swisslog/work_packages')

header = {
  'Content-Type' => 'application/json'
}

package = {
  _links: 
    {
      assignee: {
          href: '/api/v3/users/386', 
      }, 
      priority: {
         href: '/api/v3/priorities/4' 
      }, 
      responsible: {
         href: '/api/v3/users/386', 
      }, 
      status: {
         href: '/api/v3/statuses/1' 
      }, 
      type: {
         href: '/api/v3/types/3' 
      }, 
      version: {
         href: '/api/v3/versions/1476'
      }
   }, 
   dueDate: '2018-02-10', 
   lockVersion: 0, 
   startDate: '2016-02-08', 
   subject: 'Ein per schicker Ruby-Hackerei estellte Workpackage. Judihui',
   description: {
    format: 'textile',
    raw: 'Develop super cool OpenProject API.',
    html: '<p>Develop super cool OpenProject API.</p>'
   }
 }


http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
req = Net::HTTP::Post.new(uri.request_uri, header)
req.basic_auth 'apikey', '0a8204d8510dddd7cf3ccedb8e16891c6b278e59'
req.body = package.to_json


res = http.request(req)
#  parsed = JSON.parse(res.header)
#  puts parsed

puts res.body

