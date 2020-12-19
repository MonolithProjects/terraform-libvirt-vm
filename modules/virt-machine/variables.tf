#### Storage ####

variable "libvirt_disk_path" {
  description = "Path to libvirt Disk pool"
  default     = "/mnt/terra"
}

#### Virtual Machine ####

variable "os_img_url" {
  description = "URL to the OS image"
  default     = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
}

variable "vm_count" {
  description = "Number of VMs"
  default = 1
}

variable "vm_hostname_prefix" {
  description = "VM hostname prefix"
  default     = "vm"
}

variable "hostname" {
  description = "VM hostname or FQDN"
  type        = string
  default     = "server"  
}

variable "memory" {
  description = "RAM in MB"
  type = string
  default = "512"
}

variable "vcpu" {
  description = "Number of vCPUs"
  type = string
  default = 1
}

variable "dhcp" {
  description = "Use DHCP or Static IP settings"
  type        = bool
  default     = false
}

variable "ip_address" {
  description = "List of IP addresses"
  type        = list(string)
  default     = [ "192.168.123.1" ]
}

variable "ssh_keys" {
  description = "List of public ssh keys"
  type        = list(string)
  default     = []
}

variable "admin_passwd" {
  description = "Admin user password"
  default     = "password_example"
}

#### Connection test (Optional) ###

variable "ssh_username" {
  description = "User for SSH test"
  default     = "ssh-user"
}

variable "ssh_private_key" {
  description = "Private key for SSH test"
  default     = "~/.ssh/id_ed25519"
}
