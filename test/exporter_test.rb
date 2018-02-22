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

class ExporterTest < Minitest::Test

  def test_if_export_raise_exception_and_url
    options = {
      source: 'test/test_file.xml',
      project_id: '666',
      source_tool: 'bugzilla',
      api_key: 'th1s1s4t3st',
      url:  'https://something.thisandthat-works.com'
    }
    openproject_workpackages = Importer.export_issues(options)

    exporter = Exporter.new(openproject_workpackages, options[:url], options[:project_id], options[:api_key])

    exception = assert_raises(Exception) do
      exporter.export
    end

    assert_equal 'Connection failed, check your url and apikey', exception.message

  end
end
