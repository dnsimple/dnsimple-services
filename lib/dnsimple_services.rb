require_relative 'dnsimple_services/verifier'
require_relative 'dnsimple_services/logger/stdout'

module DnsimpleServices
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
    raise GeneratorError, "Service already exists" if File.exist?(outdir)

    label ||= DEFAULT_LABEL

    FileUtils.mkdir_p outdir
    FileUtils.cp Dir["example/*"], outdir
    config_path = "#{outdir}/config.json"
    config = File.read config_path
    open(config_path, 'w') do |f|
      vars = { name: name, label: label }
      f.write(config % vars)
    end
  end

  def self.verify(name, logger = Logger::Stdout.new)
    raise VerifierError, "Name is required" unless name

    problems, recommendations = Verifier.new(name).verify

    logger << ""
    if problems.empty?
      logger << "Service definition for #{name} successfully verified."
    else
      logger << "#{problems.length} issues with #{name}:"
      logger << ""
      problems.each do |description|
        logger << " * #{description}"
      end
    end

    unless recommendations.empty?
      logger << ""
      logger << "#{recommendations.length} recommendations for #{name}:"
      logger << ""
      recommendations.each do |description|
        logger << " * #{description}"
      end
    end

    logger << ""
  end


end
