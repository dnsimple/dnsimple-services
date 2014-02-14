require 'yajl'
require 'dimensions'

require_relative 'lib/dnsimple_services'

## The following are used by Rake

task default: [:verify]

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

  if name
    begin
      DnsimpleServices.verify(name)
    rescue DnsimpleServices::VerifierError => e
      puts "Error: #{e}"
    end
  else
    Dir.entries("services").reject { |n| n == "." || n == ".." }.each do |service_name|
      puts "Checking #{service_name}"
      begin
        DnsimpleServices.verify(service_name)
      rescue DnsimpleServices::VerifierError => e
        puts "Error: #{e}"
      end
    end
  end
end
