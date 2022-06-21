module DnsimpleServices
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
      problems << "The service directory for #{name} does not exist" unless File.exist?(outdir)
      problems << "A service must have a logo.png file that is 228 x 78 pixels" unless valid_logo?
      if File.exist?(config_path)
        verify_config
      else
        problems << "A service must have a valid config.json file"
      end

      recommendations << "A service should have a readme.md file" unless File.exist?("#{outdir}/readme.md")

      [problems, recommendations]
    end

    private

    def valid_logo?
      File.exist?(logo_path) && Dimensions.dimensions(logo_path) == LOGO_DIMENSIONS
    end

    def verify_config
      config = Yajl::Parser.parse(File.read(config_path))
      if config
        verify_config_data(config['config'])
        verify_records(config['records'])
      else
        problems << "A service config.json must define a JSON object"
      end
    rescue Yajl::ParseError => exception
      problems << "JSON #{exception}"
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
        problems << "The service name may only include the lowercase characters a-z, 0-9 and the dash character" unless /^[a-z0-9-]+$/.match?(config_name)
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

        records.each_with_index do |record, index|
          %w(type ttl content).each do |attr|
            problems << "Record #{index + 1} is missing the #{attr} attribute" unless record[attr]
          end
        end
      else
        problems << "A service config.json must have a 'records' section"
      end
    end
  end
end
