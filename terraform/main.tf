provider "libvirt" {
    uri = "qemu:///system"
}

resource "libvirt_volume" "master-qcow2" {
  name   = "master-qcow2"
  pool   = "default"
#   source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1809.qcow2"
#   source = "CentOS-7-x86_64-GenericCloud-1809.qcow2"
  source = "ubuntu-18.04-server-cloudimg-amd64.img"
  format = "qcow2"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/cloud_init.cfg")}"
}

data "template_file" "network_config" {
  template = "${file("${path.module}/network_config.cfg")}"
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = "${data.template_file.user_data.rendered}"
  network_config = "${data.template_file.network_config.rendered}"
}


// set boot order hd, network
resource "libvirt_domain" "domain-master-qcow2" {
  name   = "master-1"
  memory = "4096"
  vcpu   = 4

  cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"

  network_interface {
    bridge = "virbr0"
  }

  boot_device {
    dev = ["hd", "network"]
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  disk {
    volume_id = "${libvirt_volume.master-qcow2.id}"
  }

}
