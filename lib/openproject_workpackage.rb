# encoding: utf-8

#  Copyright (c) 2016, Puzzle ITC GmbH. This file is part of
#  2Openproject and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/2Openproject.

class OpenprojectWorkpackage
  ATTRSLINKS = [:status, :type, :priority, :version]
  ATTRS = [:_type, :_links, :subject, :startDate, :description]

  attr_accessor(*ATTRS)
  attr_accessor(*ATTRSLINKS)

  def initialize(params = {})
    params.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def to_json
    key_value_hash.to_json
  end

  def key_value_hash
    kv = {}
    ATTRS.each do |a|
      kv[a] = send(a)
    end
    kv
  end

end
