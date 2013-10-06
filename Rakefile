require 'yajl'
require 'dimensions'

class DnsimpleServices
  DEFAULT_LABEL = "Printable name for the service"
  DEFAULT_DESCRIPTION = "This is a short description of the service"

  LOGO_DIMENSIONS = [228, 78]

  class GeneratorError < RuntimeError
  end

  class VerifierError < RuntimeError
  end

  def self.generate(name, label)
    raise GeneratorError, "Name is required" unless name

    outdir = "services/#{name}"
    raise GeneratorError, "Service already exists" if File.exists?(outdir)

    label ||= DEFAULT_LABEL

    FileUtils.mkdir_p outdir
    FileUtils.cp Dir["example/*"], outdir
    config_path = "#{outdir}/config.json"
    config = File.read config_path
    open(config_path, 'w') do |f|
      vars = {name: name, label: label}
      f.write(config % vars)
    end
  end

  def self.verify(name)
    raise VerifierError, "Name is required" unless name

    problems, recommendations = Verifier.new(name).verify

    puts ""
    if problems.empty?
      puts "Service definition for #{name} successfully verified."
    else
      puts "#{problems.length} issues with #{name}:"
      puts ""
      problems.each do |description|
        puts " * #{description}"
      end
    end

    unless recommendations.empty?
      puts ""
      puts "#{recommendations.length} recommendations for #{name}:"
      puts ""
      recommendations.each do |description|
        puts " * #{description}"
      end
    end

    puts ""
  end

  class Verifier
    attr_reader :name
    attr_reader :problems, :recommendations

    attr_reader :outdir, :config_path, :logo_path

    def initialize(name)
      @name = name
      @problems = []
      @recommendations = []

      @outdir = "services/#{name}"
      @config_path = "#{outdir}/config.json"
      @logo_path = "#{outdir}/logo.png"
    end

    def verify
      problems << "The service directory for #{name} does not exist" unless File.exists?(outdir)
      problems << "A service must have a logo.png file that is 228 x 78 pixels" unless valid_logo? 
      if File.exists?(config_path)
        begin
          config = Yajl::Parser.parse(File.read(config_path))
          if config
            verify_config_data(config['config'])
            verify_records(config['records'])
          else
            problems << "A service config.json must define a JSON object"
          end
        rescue Yajl::ParseError => e
          problems << "JSON #{e}"
        end
      else
        problems << "A service must have a valid config.json file"
      end


      recommendations << "A service should have a readme.md file" unless File.exists?("#{outdir}/readme.md")

      [problems, recommendations]
    end

    private
    def valid_logo?
      File.exists?(logo_path) && Dimensions.dimensions(logo_path) == LOGO_DIMENSIONS 
    end

    def verify_config_data(config_data)
      if config_data
        verify_config_name(config_data['name'])
        verify_config_label(config_data['label'])
        verify_config_description(config_data['description'])
      else
        problems << "A service config.json must have a 'config' section"
      end
    end

    def verify_config_name(config_name)
      if config_name
        problems << "The service name may only include the lowercase characters a-z, 0-9 and the dash character" unless config_name =~ /^[a-z0-9-]+$/
        recommendations << "The service config name should be the same as the service directory name" if config_name != name
      else
        problems << "The service config must have a name attribute"
      end
    end

    def verify_config_label(config_label)
      if config_label
        recommendations << "The service config label should be set to something useful" if config_label == DEFAULT_LABEL
      else
        problems << "A service config must have a label attribute"
      end
    end

    def verify_config_description(config_description)
      if config_description
        recommendations << "The service config description should be set to something useful" if config_description == DEFAULT_DESCRIPTION
      else
        problems << "A service config must have a description attribute"
      end
    end

    def verify_records(records)
      if records
        problems << "A service records section must be a list of services with at least one service" unless records.is_a?(Array) && records.length >= 1
      else
        problems << "A service config.json must have a 'records' section"
      end
    end
  end
end

## The following are used by Rake

task default: [:validate]

desc "Generate a new service"
task :generate, :name do |t, args|
  name = args[:name]
  label = args[:label] 

  begin
    DnsimpleServices.generate(name, label)
  rescue DnsimpleServices::GeneratorError => e
    puts "Error: #{e}"
  end
end

desc "Verify a service"
task :verify, :name do |t, args|
  name = args[:name]

  begin
    DnsimpleServices.verify(name)
  rescue DnsimpleServices::VerifierError => e
    puts "Error: #{e}"
  end
end
