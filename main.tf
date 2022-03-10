terraform {
 required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.14"
    }
  }
}

# Provider instance
provider "libvirt" {
  uri = "qemu:///system"
}

##### GLOBAL #####
variable "ssh_pub_key" {
    type = string
    default = "A CHANGER"
}

# VMs Image
variable "os_image" {
    type    = string
    default = "https://cloud-images.ubuntu.com/releases/21.10/release/ubuntu-21.10-server-cloudimg-amd64-disk-kvm.img"
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/cloud_init.cfg")
  vars = {
      SSH_PUB_KEY = var.ssh_pub_key
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
}