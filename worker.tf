variable "worker" {
    type = map
    default = {
        number = 3
    }
}

resource "libvirt_volume" "ubuntu-worker-qcow2" {
    count = var.worker.number
    name   = "${format("ubuntu-worker-qcow2-%03d", count.index + 1)}"
    source = var.os_image
    format = "qcow2"
}

resource "libvirt_domain" "domain-ubuntu-worker" {
  count = var.worker.number
  name   = "${format("worker-%03d", count.index + 1)}"
  memory = "4096"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.commoninit.id


  network_interface {
    network_name = "default"
  }

  disk {
    volume_id = libvirt_volume.ubuntu-worker-qcow2[count.index].id
  }
}