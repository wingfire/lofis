require 'yaml'
require 'pathname'
require 'yaml_waml'
$KCODE = 'UTF8'
root = Pathname.new(__FILE__).dirname

load root.join('Rakefile.jeweler')

task :default => :compile

desc 'compile multiple lofis files into one'
task :compile, :files do |t, args|
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
    f.puts "# Lofis version #{File.read('VERSION')} "
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
