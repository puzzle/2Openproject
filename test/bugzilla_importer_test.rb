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

  def test_convert_bugzilla_bug_to_openproject_workpackage
    options = {
      source: 'test/test_file.xml',
      project_id: '183',
      source_tool: 'bugzilla',
      status_id: 1,
      type_id: 2 ,
      priority_id: 4
    }

    openproject_workpackages = Importer.export_issues(options)

    openproject_workpackage = openproject_workpackages[0]
    assert_equal "#1 - Test eines Testes", openproject_workpackage.subject
    description = "BugzillaBug for Test (Logik) 2: \nStatus: NEW / Priority: P1 / Severity: enhancement \n\n \n*2014-01-01 16:48:53 +0200, :* \n<pre>\n        Test Issue for Script\n      </pre>"
#require 'pry'; binding.pry
    assert_equal description, openproject_workpackage.description[:raw]
    assert_equal "2014-01-01", openproject_workpackage.startDate
    assert_equal "/api/v3/statuses/1", openproject_workpackage._links[:status][:href]
    assert_equal "/api/v3/priorities/4", openproject_workpackage._links[:priority][:href]
    assert_equal "/api/v3/types/2", openproject_workpackage._links[:type][:href]
    

    second_bug_description = "BugzillaBug for Test (Logik) 2: \nStatus: NEW / Priority: P1 / Severity: enhancement \n\n \n*2014-01-01 16:48:53 +0200, :* \n<pre>\n        Second Test Issue for Script\n      </pre>"
    assert_equal second_bug_description, openproject_workpackages[1].description[:raw]
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
