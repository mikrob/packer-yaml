require 'thor'

module Packer
  class Cli < Thor

    desc "make_json FILE", "transform given yaml file into valid packer json format"
    long_desc <<-EOF
    Packer-Yaml a tool to manage packer definition in YAML with includes.
    EOF
    method_option :file, :type => :string
    def make_json(file)
      file_name = File.basename(file, ".*" )
      if File.exist?(file)
        packer_yaml = Packer::Yaml.new(file_name, file)
        packer_yaml.output_json
      else
        puts "File doesn't exist"
      end
    end

    desc "validate FILE", "transform given yaml file into valid packer json and check it is valid json and valid packer description"
    long_desc <<-EOF
    Packer-Yaml a tool to manage packer definition in YAML with includes.
    EOF
    method_option :file, :type => :string
    def validate(file)
      Packer::Yaml.validate(file)
      runner = Packer::Runner.new
      runner.run_packer_validate(file)
    end

  end

end