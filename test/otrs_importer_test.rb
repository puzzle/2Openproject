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
      source_tool: 'otrs'
    }

    otrs_importer = OtrsImporter.new(options)
    otrs_importer.expects(:tickets).returns(ticket)
    otrs_importer.expects(:query_tickets_filter).returns(ticket)
    otrs_importer.expects(:otrs_ticket_status).with(ticket.first[:ticket_state_id]).returns('new').times(3)
    otrs_importer.expects(:ticket_articles).with(ticket.first[:id]).returns(article).times(3)
    Importer.expects(:initialize_importer).with(options).returns(otrs_importer)

    redmine_issue = Importer.redmine_issues(options)

    redmine_issue = redmine_issue.first
    assert_equal "666", redmine_issue.project_id
    assert_equal 2, redmine_issue.tracker_id
    assert_equal "test the test ticket for testing something for test reason", redmine_issue.subject
    description = "OTRS \nOriginally reported by: test@test.ch \n \n*2012-01-06 10:30:02 +0100, Markus Tester <tester@test.ch>:* \n<pre>Dies ist der body eines article und zugleich auch ein Test</pre>"
    assert_equal description, redmine_issue.description
    assert_equal "2012-01-06", redmine_issue.start_date
    assert_equal "2012-01-06", redmine_issue.created_on
    assert_equal "2012-03-28", redmine_issue.updated_on
    assert_equal nil, redmine_issue.story_points
    assert_equal 1, redmine_issue.status_id
    assert_equal 4, redmine_issue.priority_id
    assert_equal false, redmine_issue.is_private
  end



  private

  def ticket
    ticket =  [{  id: 2462,
                 tn: "0313524598",
                 title: "test the test ticket for testing something for test reason",
                 queue_id: 40,
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
    article =   [{create_time: "2012-01-06 10:30:02 +0100",
                 a_from: "Markus Tester <tester@test.ch>",
                 a_body: "Dies ist der body eines article und zugleich auch ein Test"}]
  end


end
