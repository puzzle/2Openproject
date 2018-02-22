# encoding: utf-8

#  Copyright (c) 2016, Puzzle ITC GmbH. This file is part of
#  2Redmine and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/2Redmine.

require 'date'
require 'json'
require 'sequel'
require_all 'lib'
require 'restclient'
require 'require_all'
require 'mocha/mini_test'
require 'minitest/autorun'
require 'active_support/inflector'

class OtrsImporterTest < Minitest::Test
  def test_otrs
    options = {
      query: "test",
      project_id: '666',
      source_tool: 'otrs',
      status_id: 1,
      type_id: 2 ,
      priority_id: 4
    }

    otrs_importer = OtrsImporter.new(options)
    otrs_importer.expects(:tickets).returns(ticket)
    otrs_importer.expects(:query_tickets_filter).returns(ticket)
    otrs_importer.expects(:otrs_ticket_status).with(ticket.first[:ticket_state_id]).returns('new').times(3)
    otrs_importer.expects(:ticket_articles).with(ticket.first[:id]).returns(article).times(3)
    Importer.expects(:initialize_importer).with(options).returns(otrs_importer)

    openproject_workpackages = Importer.export_issues(options)

    openproject_workpackage = openproject_workpackages.first
    assert_equal "test the test ticket for testing something for test reason", openproject_workpackage.subject
    description = "OTRS\nOriginally reported by: test@test.ch \n \n*2012-01-06 10:30:02 +0100, Markus Tester <tester@test.ch>:* \nDies ist der body eines article und zugleich auch ein Test"
# require 'pry'; binding.pry
    assert_equal description, openproject_workpackage.description[:raw]
    assert_equal "2012-01-06", openproject_workpackage.startDate
    assert_equal "/api/v3/statuses/1", openproject_workpackage._links[:status][:href]
    assert_equal "/api/v3/priorities/4", openproject_workpackage._links[:priority][:href]
    assert_equal "/api/v3/types/2", openproject_workpackage._links[:type][:href]
  end

  def test_otrs_queue_not_found
    options = {
      project_id: '666',
      source_tool: 'otrs',
      queue: 'batzelhanft'
    }

    otrs_importer = OtrsImporter.new(options)
    otrs_importer.expects(:tickets).returns(ticket)
    Importer.expects(:initialize_importer).with(options).returns(otrs_importer)

    e = assert_raises(RuntimeError) do
      Importer.export_issues(options)
    end
    
    assert_match(/Queue batzelhanft not found/, e.message)
  end


  private

  def ticket
    [{  id: 2462,
                 tn: "0313524598",
                 title: "test the test ticket for testing something for test reason",
                 queue_id: 43,
                 ticket_lock_id: 1,
                 type_id: 1,
                 service_id: nil,
                 sla_id: nil,
                 user_id: 1,
                 responsible_user_id: 1,
                 ticket_priority_id: 3,
                 ticket_state_id: 3,
                 customer_id: "test@test.ch",
                 customer_user_id: "test",
                 timeout: 0,
                 until_time: 0,
                 escalation_time: 0,
                 escalation_update_time: 0,
                 escalation_response_time: 0,
                 escalation_solution_time: 0,
                 create_time_unix: 1325842202,
                 create_time: "2012-01-06 10:30:02 +0100",
                 create_by: 1,
                 change_time: "2012-03-28 15:50:47 +0200",
                 change_by: 37,
                 archive_flag: 0}]
  end


  def article
    [{create_time: "2012-01-06 10:30:02 +0100",
                 a_from: "Markus Tester <tester@test.ch>",
                 a_body: "Dies ist der body eines article und zugleich auch ein Test"}]
  end


end
