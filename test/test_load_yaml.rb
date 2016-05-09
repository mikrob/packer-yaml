require "test/unit"
require 'packer-yaml'
require 'pp'

class TestLoadYaml < Test::Unit::TestCase

    CONFIG_PATH = File.expand_path("../../examples/", __FILE__)

    def test_load_yaml
      yaml = PackerYaml.read("#{CONFIG_PATH}/packer1.yaml")
      assert_equal "googlecompute", yaml[:builders][1][:type]
      assert_equal "amazon-ebs", yaml[:builders][0][:type]
      assert_equal "#!/bin/bash", yaml[:provisioners].first[:inline].first
      assert_equal "sudo apt-get -y install ssh", yaml[:provisioners].first[:inline][6]
    end

    def test_yaml_and_json_are_equal
      yaml = PackerYaml.read("#{CONFIG_PATH}/packer1.yaml")
      json = JSON.prase("#{CONFIG_PATH}/packer1.json")

      pp yaml

      pp json
    end
end