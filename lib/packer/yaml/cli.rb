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
      file_name = File.basename(file, ".*" )
      if File.exist?(file)
        packer_yaml = Packer::Yaml.new(file_name, file)
        if packer_yaml.is_valid_json?
          puts "Generated JSON is valid, your YAML is good!"
        else
          puts "Generated JSON is not valid"
        end
      else
        puts "Given file doesn't exist"
      end
    end

  end

end