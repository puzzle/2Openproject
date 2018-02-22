# encoding: utf-8

#  Copyright (c) 2018, Puzzle ITC GmbH. This file is part of
#  2Openproject and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/2Openproject.
 
class BugzillaImporter < Importer

  def initialize(params)
    @params = params
  end

  def import_source_entries
    abort 'File does not exist' unless File.exist?(@params[:source])
    begin
      file = File.read(@params[:source])
      xmlfile = XmlSimple.xml_in(file)
      return xmlfile['bug']
    rescue => e
      abort e.to_s
    end
  end

  #
  # openproject_workpackage Attributes
  #

  def format_date(date_str)
    Date.parse(date_str).to_s
  end

  def project(issue)
    @params[:project_id]
  end

  def _type(ticket)
    pack = "WorkPackage"
    pack
  end

  def startDate(issue)
    format_date(issue['creation_ts'][0])
  end

  def estimated_hours(issue)
    issue['estimated_time'][0]
  end

  def tracker_id(issue)
    issue['bug_severity'][0] == 'enhancement' ? 2 : 1
  end

  def _links(issue)
    links = {priority: {href: "/api/v3/priorities/#{@params[:priority_id]}"}, status: {href: "/api/v3/statuses/#{@params[:status_id]}"}, type: {href: "/api/v3/types/#{@params[:type_id]}"},version: {href: "/api/v3/versions/#{@params[:version_id]}"}}
    links
  end

  def description(issue)
    desc = "BugzillaBug for #{issue['product'][0]} (#{issue['component'][0]}) #{issue['version'][0]}: \n"
    desc += "Status: #{issue['bug_status'][0]} / Priority: #{issue['priority'][0]} / Severity: #{issue['bug_severity'][0]} \n"
    issue['cf_customer'].nil? ? desc += "\n \n" : desc += "Reporting Customer: #{issue['cf_customer'][0]} \n \n"


    issue['long_desc'].each do |ld|
      desc += "*#{ld['bug_when'][0]}, #{ld['who'][0]['content']}:* \n"
      desc += "<pre>#{ld['thetext'][0]}</pre>"
    end
    desc_short=desc[0..63000].gsub('','')
    finaldesc = {format: 'textile', raw: "#{desc_short}"}
  end

  def subject(issue)
    "##{issue['bug_id'][0]} - #{issue['short_desc'][0]}"
  end

  def status(issue)
    @params[:status_id]
  end
end
