require 'yaml'
require 'pathname'
$KCODE = 'UTF8'

class String
  def to_yaml( opts = {} )
    YAML::quick_emit( is_complex_yaml? ? self : nil, opts ) do |out|
      if to_yaml_properties.empty?
        out.scalar( taguri, self, self =~ /^:/ ? :quote2 : to_yaml_style )
      else
        out.map( taguri, to_yaml_style ) do |map|
          map.add( 'str', "#{self}" )
          to_yaml_properties.each do |m|
            map.add( m, instance_variable_get( m ) )
          end
        end
      end
    end
  end
end

task :default => :compile

desc 'compile multiple lofis files into one'
task :compile, :files do |t, args|
  root = Pathname.new(__FILE__).dirname
  
  files = if args.files
            Dir[args.files]
          else
            Dir[root.join('source', '*.yml').to_s]
          end.map { |p| Pathname.new(p) }

  result = Hash.new { |h,k| h[k] = [] }
  
  files.each do |file|
    print "including #{file}"

    data = YAML.load_file(file.to_s)
    
    if !data || !data.is_a?(Hash) || !data['umlaut']
      puts ' - no lofis data found'
      next
    end

    data['umlaut'].each do |k,v|
      result[k].concat(v)
    end

    puts

  end

  result.each do |k,v|
    result[k] = v.uniq
  end

  puts "writing lofis.yml"
  root.join('lofis.yml').open('w') do |f|
    f.puts "# #{File.read('VERSION')} "
    f.puts "# compiled at #{Time.now.utc}"
    f.puts "# "
    f.puts "# included files:"
    
    files.each do |file|
      f.puts "#   #{file.relative_path_from(root)}"
    end

    f.puts
    
    { 'umlaut' => result }.to_yaml(f)
  end
  
end
