require 'yaml'

module Lofis

  class Error < StandardError
  end

  def self.mapping
    @mapping ||= load_file(File.join(File.dirname(__FILE__), '..', 'lofis.yml'))
    @mapping || raise(Error, 'no lofis file loaded')
  end

  def self.load_file(file)
    @mapping = YAML.load_file(file)['umlaut'].map { |r,s| [Regexp.new(s.map { |c| Regexp.escape(c) }.join('|')), r] }
  end

  def self.to_sortable(s)
    mapping.inject(s) do |g,(s,r)|
      g.gsub(s, r)
    end
  end

  def to_sortable
    @_lofis_sortable ||= Lofis.to_sortable(self)
  end
  
end
