require "packer/yaml/version"
require "packer/yaml/cli"
require 'yaml'
require 'json'
require 'pp'

module Packer
  class Yaml
    def initialize name, file_path
      @name = name
      @yaml = Packer::Yaml::read(file_path)
    end

    def self.read file_path
      begin
        yaml = YAML.load_file(file_path)
        yaml.each do |type,content|
          if type == "variables"
            include_var = nil
            content.each do |k,v|
              if k == :include
                v = "#{v}.yml" unless v.end_with?(".yml")
                include_var = YAML.load_file(File.join(File.dirname(file_path), v))
              end
            end
            content.delete(:include)
            content.merge!(include_var) if include_var
          else
            include_content = nil
            replacements = {}
            content.each_with_index do |line, index|
              line.each do |k,v|
                if k == :include
                  v = "#{v}.yml" unless v.end_with?(".yml")
                  include_content = YAML.load_file(File.join(File.dirname(file_path), v))
                  replacements[index] = include_content
                end
              end
            end
            replacements.each do |idx, value|
              if value.is_a? Array
                content.delete_at(idx)
                value.each_with_index do |val, idx_val|
                  content.insert(idx + idx_val, val)
                end
              else
                content[idx] = value
              end
            end
          end
        end
      rescue
        puts "Your file is not a yaml valid file"
        yaml = File.read(file_path)
      end
      yaml
    end

    def to_hash
      @yaml
    end

    def to_json
      begin
        JSON.pretty_generate(@yaml) if @yaml
      rescue
        @yaml
      end
    end

    def is_json_valid?
      result, error = Packer::Yaml.valid_json?(to_json)
      if error
        puts "Error during json validation : "
        p error
      end
      result
    end

    def self.valid_json?(json)
      begin
        JSON.parse(json)
        return [true, nil]
      rescue JSON::ParserError => e
        return [false, e]
      rescue Psych::SyntaxError => e
        return [false, e]
      end
    end

    def self.validate file
      if File.exist?(file)
        file_name = File.basename(file, ".*" )
        packer_yaml = Packer::Yaml.new(file_name, file)
        if packer_yaml.is_json_valid?
          puts "Generated JSON is valid, your YAML is good!"
        else
          puts "Generated JSON is not valid"
        end
      else
        puts "Given file doesn't exist"
      end
    end

    def output_json
      $stdout.write(to_json)
    end
  end

  class Runner
    def which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        }
      end
      return nil
    end

    def check_packer_installed
      which("packer")
    end

    def run_packer(file)
      cmd = which("packer")

      %x[#{cmd}  ]
    end

    def run_packer_validate(file)

    end

  end

end
