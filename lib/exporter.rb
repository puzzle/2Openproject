# encoding: utf-8

#  Copyright (c) 2018, Puzzle ITC GmbH. This file is part of
#  2Openproject and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/2Openproject.

require 'xmlsimple'
require 'json'
require 'uri'
require 'net/http'
require 'net/https'
#require 'pry'

class Exporter 

  def initialize (workpackage, url, project_id, api_key)
#    puts url
#    puts project_id
#    puts api_key
    @workpackage = workpackage
    @url = "https://#{url}/api/v3/projects/#{project_id}/work_packages?notify=false"
    @api_key = api_key
#    puts "Initialize export object"
  end

  def export
    puts "Nun in def export"

    @workpackage.each do |wp|
      header = {
        'Content-Type' => 'application/json'
      }
#      puts header
#      puts @url

      uri = URI.parse(@url)
 #     puts uri

#      puts "set http"
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

#      puts "Ein Versuch"

#      puts "set request"
#      puts uri.scheme
#      puts uri.request_uri
      req = Net::HTTP::Post.new(uri.request_uri, header)
#      puts "set basic auth"
      req.basic_auth 'apikey', @api_key

      puts "wp.to_json:"
      puts wp.to_json
#binding.pry
#      puts "set req.body:"
      req.body = wp.to_json
#      puts req.body
      res = http.request(req)
      puts "Response:"
      puts res
      puts res.inspect
      puts "Inspect Body:"
      puts res.body

      puts "exported workpackage: #{wp.subject}"
    end
  rescue Exception
    abort 'Connection failed, check your url and apikey'
  end
end
