# encoding: utf-8

#  Copyright (c) 2018, Puzzle ITC GmbH. This file is part of
#  2Openproject and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/2Openproject.

class OtrsImporter < Importer

  def initialize(params)
    @params = params
  end

  #
  # Main method
  #
  def import_source_entries
    otrs_tickets = @params[:queue].nil? ? tickets : queue_tickets
    @params[:query].nil? ? otrs_tickets : query_tickets_filter(otrs_tickets)
  end

  #
  # openproject_workpackage Attributes
  #
  def project(ticket)
    @params[:project_id]
  end

  def _type(ticket)
    pack = "WorkPackage"
    pack
  end

  def startDate(ticket)
    format_date(ticket[:create_time].to_s)
  end

  def description(ticket)
    desc = "OTRS\n"
    ticket[:customer_id].nil? ? desc += "\n \n" : desc += "Originally reported by: #{ticket[:customer_id]} \n \n"

    ticket_articles(ticket[:id]).reverse_each do |ta|
      desc += "*#{ta[:create_time]}, #{ta[:a_from]}:* \n"
      desc += "#{ta[:a_body]}"
    end
    # limit description size, mysql collumn fits only 64kByte:
    desc_short=desc[0..63000].gsub('','')
    finaldesc = {format: 'textile', raw: "#{desc_short}"}

    finaldesc
  end

  def subject(ticket)
    ticket[:title]
  end

  def priority(ticket)
    ticket[:priority_id]
  end

  def type(ticket)
    ticket[:type_id]
  end


  def status(ticket)
    status = otrs_ticket_status(ticket[:ticket_state_id])
    openproject_status_id = case status
    when 'new' then 1
    when 'check efficacy' then 7
    else 3
    end
    openproject_status_id
  end

  def version(ticket)
    @params[:version_id]
  end

  def _links(ticket)
    links = {priority: {href: "/api/v3/priorities/#{@params[:priority_id]}"}, status: {href: "/api/v3/statuses/#{@params[:status_id]}"}, type: {href: "/api/v3/types/#{@params[:type_id]}"}, version: {href: "/api/v3/versions/#{@params[:version_id]}"}}
    links
  end


  private
  #
  # Helpermethods
  #
  def ticket_status_check_efficacy(ticket)
    otrs_ticket_status(ticket[:ticket_state_id]) == 'check efficacy'
  end

  def ticket_status_closed_successful(ticket)
    !article_check(ticket[:id]) && otrs_ticket_status(ticket[:ticket_state_id]) == 'closed successful'
  end

  def article_check(ticket_id)
    article = ticket_articles(ticket_id)
    article.find {|a| a[:a_subject] == 'Wirksamkeit geprüft'}.nil?
  end

  def format_date(date_str)
    Date.parse(date_str).to_s
  end

  def query_tickets_filter(otrs_tickets)
    otrs_tickets.where(Sequel.like(:title, /#{@params[:query]}.*/))
  end

  #
  # Database connection and credentials
  #
  def db_connect
    con = Sequel.mysql(adapter: 'mysql2',
                       user: db_credentials['Username'],
                       host: db_credentials['Host'],
                       database: db_credentials['Database'],
                       password: db_credentials['Password'],
                       encoding: 'utf8')
    con.test_connection rescue abort "Can't connect to Database"
    con
  end

  def db_credentials
    YAML.load(File.read('db_credentials.yml'))
  end

  #
  # Database Requests
  #
  def otrs_ticket_status(ticket_state_id)
    otrs_db["select name from ticket_state where id = #{ticket_state_id.to_s}"].first[:name]
  end

  def queue_id
    otrs_db["select id from queue where name like '#{@params[:queue]}'"]
  end

  def tickets
    otrs_db[:ticket]
  end

  def queue_tickets
    tickets.where(queue_id: queue_id.first[:id].to_s)
  rescue NoMethodError
    raise 'Queue ' + @params[:queue] + ' not found in database'
  end

  def ticket_articles(ticket_id)
    otrs_db[:article].where(ticket_id: ticket_id)
  end

  def otrs_db
    @db ||= db_connect
  end
end
