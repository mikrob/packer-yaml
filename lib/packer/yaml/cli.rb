require 'thor'

module Packer
  class Cli < Thor
    desc "Packer-Yaml a tool to manage packer definition in YAML with includes"
    long_desc <<-EOF
    Packer-Yaml a tool to manage packer definition in YAML with includes.
    EOF

    option :file
    def make_json( name )
      greeting = "Hello, #{name}"
      greeting.upcase! if options[:file]
      puts greeting
    end

  end

end