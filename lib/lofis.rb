require 'yaml'

module Lofis

  class Error < StandardError
  end

  def self.mapping
    @mapping || raise(Error, 'no lofis file loaded')
  end

  def self.load_file(file)
    @mapping = YAML.load_file(file)['umlaut'].map { |r,s| [Regexp.new(s.map { |c| Regexp.escape(c) }.join('|')), r] }
  end

  def self.convert(s)
    @mapping.inject(s) do |g,(s,r)|
      g.gsub(s, r)
    end
  end
  
end
