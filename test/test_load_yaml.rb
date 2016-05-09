require "test/unit"
require 'packer-yaml'
require 'pp'

class TestLoadYaml < Test::Unit::TestCase

    CONFIG_PATH = File.expand_path("../../examples/", __FILE__)

    def test_load_yaml
      yaml = PackerYaml.read("#{CONFIG_PATH}/packer1.yaml")
      pp yaml
      p yaml[:provisioners].first[:inline].first
      assert_equal "#!/bin/bash", yaml[:provisioners].first[:inline].first
    end
end