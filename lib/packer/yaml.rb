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
      yaml
    end

    def to_hash
      @yaml
    end

    def to_json
      JSON.pretty_generate(@yaml)
    end

    def valid_json?
      begin
        JSON.parse(to_json)
        return true
      rescue JSON::ParserError => e
        return false
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

    def run_packer(file)

    end

    def run_packer_validate(file)

    end

  end

end
