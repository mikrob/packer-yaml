# packer-yaml

This gem allow you to make your packer file in yaml.
Yaml is better than json for packer because :

* Yaml allow comment (json doesn't)
* Yaml allow include and avoid copy/paste if you have several packer builder which differences

In my case i had a few differences between docker, aws, openstack and gce so i finished with a lot of packer files which is hard to maintain.
Moreover, when you use things like GCE Instances Group you should have an image per kind of VMs. So many and many packer json files to maintain with a lot of code duplication.

Packer Yaml allow you to avoid this boring code duplication due to JSON format.
