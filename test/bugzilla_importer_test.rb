# encoding: utf-8

#  Copyright (c) 2016, Puzzle ITC GmbH. This file is part of
#  2Redmine and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/2Redmine.

require 'require_all'
require 'minitest/autorun'
require 'date'
require 'json'
require 'restclient'
require_all 'lib'
require 'active_support/inflector'

class BugzillaImporterTest < Minitest::Test

  def test_convert_bugzilla_bug_to_redmine_issue
    options = {
      source: 'test/test_file.xml',
      project_id: '183',
      source_tool: 'bugzilla'
    }

    redmine_issues = Importer.redmine_issues(options)

    redmine_issue = redmine_issues[0]
    assert_equal "183", redmine_issue.project_id
    assert_equal 2, redmine_issue.tracker_id
    assert_equal "#1 - Test eines Testes", redmine_issue.subject
    description = "BugzillaBug for Test (Logik) 2: \nStatus: NEW / Priority: P1 / Severity: enhancement \n\n \n*2014-01-01 16:48:53 +0200, :* \n<pre>\n        Test Issue for Script\n      </pre>"
    assert_equal description, redmine_issue.description
    assert_equal "2014-01-01", redmine_issue.start_date
    assert_equal "64.00", redmine_issue.estimated_hours
    assert_equal "2014-01-01", redmine_issue.created_on
    assert_equal "2014-01-01", redmine_issue.updated_on
    assert_equal "64.00", redmine_issue.story_points
    assert_equal 1, redmine_issue.status_id
    assert_equal 4, redmine_issue.priority_id
    assert_equal false, redmine_issue.is_private
    
    second_bug_description = "BugzillaBug for Test (Logik) 2: \nStatus: NEW / Priority: P1 / Severity: enhancement \n\n \n*2014-01-01 16:48:53 +0200, :* \n<pre>\n        Second Test Issue for Script\n      </pre>"
    assert_equal second_bug_description, redmine_issues[1].description
  end

  def test_abort_if_unknown_source_tool
    options = {
      source: 'test/test_file.xml',
      project_id: "183",
      source_tool: 'ms-windows'
    }

    exception = assert_raises(Exception) do
      Importer.initialize_importer(options)
    end
    assert_equal "Source tool unknown", exception.message

  end

  def test_if_format_date_is_correct
    date = BugzillaImporter.new('test').send(:format_date, '2014-01-01 16:48:00 +0200')

    assert_equal "2014-01-01", date
  end
end
