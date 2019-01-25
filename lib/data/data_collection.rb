require 'yaml'
require 'active_support/core_ext'
require_relative 'random_data'

class DataCollection
  attr_accessor :all
  attr_accessor :current

  def initialize(yml, convert=true)
    items = YAML::load yml
    raise 'YAML input does define a hash of objects' unless items.is_a? Hash
    items.deep_symbolize_keys!
    apply_templates items
    convert_to_hash_of_objects! items if convert
    @all = items
  end

  def apply_templates items
    items.each do |k,v|
      item = items[k]
      if item.is_a?(Hash) && item.has_key?(:template)
        template = items[item[:template]]
        raise "Template #{item[:template]} is not defined" unless item[:template]
        items[k] = template.merge item
      end
    end
  end

  def convert_to_hash_of_objects!(items)
    items.each do |k, v|
      items[k] = convert_to_ostruct v
      items[k].define_singleton_method(:as_hash) { marshal_dump }
    end
  end

  def self.load_file(file_path, convert=true)
    DataCollection.new ERB.new(File.read(file_path)).result, convert
  end

  def find(name)
    key = name.gsub(/\s+/, "_").downcase.to_sym
    item = all[key]
    raise "Data for '#{name}' is not defined" unless item
    @current = item
  end

  def convert_to_ostruct(obj)
    result = obj
    if result.is_a? Hash
      result.each  do |key, val|
        result[key] = convert_to_ostruct val
      end
      result = OpenStruct.new result
    elsif result.is_a? Array
      result = result.map { |r| convert_to_ostruct r }
    end
    return result
  end

  def [](key)
    all[key]
  end

  def length
    all.length
  end

end
