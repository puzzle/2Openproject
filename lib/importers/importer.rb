# encoding: utf-8

#  Copyright (c) 2018, Puzzle ITC GmbH. This file is part of
#  2Openproject and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/2Openproject.

class Importer

  DEFAULT_VALUES = {
    status_id: 3,
    priority_id: 4,
    priority_name: 'Normal',
#    fixed_version_id: 1521
  }

  class << self
    def export_issues(options)
      @importer = initialize_importer(options)
      @source_entries = @importer.import_source_entries
      @source_entries.collect do |e|
        to_openproject_workpackage(e)
      end
    end

    def initialize_importer(options)
      importer_name = options[:source_tool].capitalize + 'Importer'
      ActiveSupport::Inflector.constantize(importer_name).new(options)
    rescue Exception
      abort 'Source tool unknown'
    end

    def to_openproject_workpackage(entry)
    params = {}
    OpenprojectWorkpackage::ATTRS.each do |a|
      params[a] = param_value(a, entry)
    end
#      puts "XXXXXXXXXXXX"
#      puts params
#      puts "YYYYY_to_JSSONA_YYYYYYYy"
#      puts params.to_json
    OpenprojectWorkpackage.new(params)
  end

    def param_value(attr, entry)
      if @importer.respond_to?(attr) && !@importer.send(attr, entry).nil?
        @importer.send(attr, entry)
      else
        DEFAULT_VALUES[attr]
      end
    end

    def import_source_entries
      raise 'implement me in subclass'
    end

  end
end
