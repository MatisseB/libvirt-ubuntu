variable "master" {
    type = map
    default = {
        number = 3
    }
}

resource "libvirt_volume" "ubuntu-master-qcow2" {
    count = var.master.number
    name   = "${format("ubuntu-master-qcow2-%03d", count.index + 1)}"
    source = var.os_image
    format = "qcow2"
}

resource "libvirt_domain" "domain-ubuntu-master" {
  count = var.master.number
  name   = "${format("master-%03d", count.index + 1)}"
  memory = "4096"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name = "default"
  }

  disk {
    volume_id = libvirt_volume.ubuntu-master-qcow2[count.index].id
  }
}