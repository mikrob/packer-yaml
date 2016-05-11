# Packer::Yaml

This gem is a command line tool to allow you to manage your packer config with YAML instead of JSON.
Indeed JSON format is not useful for theses kind of config type :
- you cannot have include so if you have some variation of your config you have to duplicate JSON config.
- packer doesn't ignore JSON comments, so you cannot comment your code
- JSON is a very strict format which is boring with this such as comma at end of line


# How to use it

First, you can take the same syntax than in packer but in YAML format.

## Example :


Main file :
```yaml
variables:
  aws_access_key: "AWS_ACCESS_KEY"
  aws_secret_key: "AWS_SECRET_KEY"
  consul_url: "https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_linux_amd64.zip"
  :include: my_yaml_vars
builders:
  - type: "amazon-ebs"
    access_key: "{{user `aws_access_key`}}"
    secret_key: "{{user `aws_secret_key`}}"
  - type: "googlecompute"
    account_file: gce.json
    project_id: mikrob
  - :include: my_yaml_builder
provisioners:
  - type: shell
    inline:
      - "#!/bin/bash"
      - sudo useradd -m deploy
      - sudo mkdir -p /home/deploy/.ssh/
      - sudo chown -R deploy /home/deploy
      - sudo chown -R deploy /home/deploy/.ssh
      - sudo mkdir -p /root/.ssh/
      - sudo apt-get -y install ssh
  - :include: my_yaml_provisionner
  - :include: my_yaml_provisionner2
```

my_yaml_vars.yml :

```yaml
customer_var: customer_var_value
google_url: google.fr
gmail_url: google.fr/gmail
```

my_yaml_builder.yml :

```yaml
type: "docker"
image: "ubuntu:14.04"
commit: true
```


my_yaml_provisionner.yml :


```yaml
- type: shell
  inline:
    - "#!/bin/bash"
    - "echo '{{user `consul_url` }}' > /opt/consul_url"
    - touch /opt/consul_url
    - curl http://google.fr
```

my_yaml_provisionner2.yml :

```yaml
- type: shell
  inline:
    - "hostname > /opt/hostname"
- type: shell
  inline:
    - "echo 'foo' > /opt/foo"
```


You can run packer_yaml make_json ./examples/packer2.yml

The following json will be generated.



```json
{
  "variables": {
    "aws_access_key": "AWS_ACCESS_KEY",
    "aws_secret_key": "AWS_SECRET_KEY",
    "consul_url": "https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_linux_amd64.zip",
    "customer_var": "customer_var_value",
    "google_url": "google.fr",
    "gmail_url": "google.fr/gmail"
  },
  "builders": [
    {
      "type": "amazon-ebs",
      "access_key": "{{user `aws_access_key`}}",
      "secret_key": "{{user `aws_secret_key`}}"
    },
    {
      "type": "googlecompute",
      "account_file": "gce.json",
      "project_id": "mikrob"
    },
    {
      "type": "docker",
      "image": "ubuntu:14.04",
      "commit": true
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "inline": [
        "#!/bin/bash",
        "sudo useradd -m deploy",
        "sudo mkdir -p /home/deploy/.ssh/",
        "sudo chown -R deploy /home/deploy",
        "sudo chown -R deploy /home/deploy/.ssh",
        "sudo mkdir -p /root/.ssh/",
        "sudo apt-get -y install ssh"
      ]
    },
    {
      "type": "shell",
      "inline": [
        "#!/bin/bash",
        "echo '{{user `consul_url` }}' > /opt/consul_url",
        "touch /opt/consul_url",
        "curl http://google.fr"
      ]
    },
    {
      "type": "shell",
      "inline": [
        "hostname > /opt/hostname"
      ]
    },
    {
      "type": "shell",
      "inline": [
        "echo 'foo' > /opt/foo"
      ]
    }
  ]
}
```

