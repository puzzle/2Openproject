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

  def initialize (workpackages, url, project_id, api_key)
    @workpackages = workpackages
    @url = "https://#{url}/api/v3/projects/#{project_id}/work_packages?notify=false"
    @api_key = api_key
  end

  def export

    @workpackages.each do |wp|
      header = {
        'Content-Type' => 'application/json'
      }

      uri = URI.parse(@url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      req = Net::HTTP::Post.new(uri.request_uri, header)
      req.basic_auth 'apikey', @api_key

      req.body = wp.to_json
      res = http.request(req)

      puts "exported workpackage: #{wp.subject}"
      new_wp = JSON.parse(res.body)
      puts "Das neu erstellte Workpackage hat die id: #{new_wp['id']}"
    end
  rescue Exception
    abort 'Connection failed, check your url and apikey'
  end

end
