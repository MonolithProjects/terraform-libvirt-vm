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
  default = "1024"
}

variable "hugepages" {
  description = "Set Hugepages"
  type = bool
  default = false
}

variable "vcpu" {
  description = "Number of vCPUs"
  default = 1
}

variable "pool" {
  description = "Storage pool name"
  default = "default"
}

variable "system_volume" {
  description = "System Volume size (GB)"
  default = 10
}

variable "share_filesystem" {
  type = object({
    source   = string
    target   = string
    readonly = bool
  })
  default = {
    source   = null
    target   = null
    readonly = false
    }
}

variable "dhcp" {
  description = "Use DHCP or Static IP settings"
  type        = bool
  default     = false
}

variable "bridge" {
  description = "Bridge interface"
  default     = "br0"
}

variable "ip_address" {
  description = "List of IP addresses"
  type        = list(string)
  default     = [ "192.168.123.101" ]
}

variable "ip_nameserver" {
  description = "IP addresses of a nameserver"
  default     = "192.168.123.1"
}

variable "ip_gateway" {
  description = "IP addresses of a gateway"
  default     = "192.168.123.1"
}

variable "ssh_admin" {
  description = "Admin user with ssh access"
  default = "ssh-admin"
}

variable "ssh_keys" {
  description = "List of public ssh keys"
  type        = list(string)
  default     = []
}

variable "local_admin" {
  description = "Admin user without ssh access"
  default     = "local-admin"
}

variable "local_admin_passwd" {
  description = "Local admin user password"
  default     = "password_example"
}

variable "time_zone" {
  description = "Time Zone"
  default     = "UTC"
}

variable "ssh_private_key" {
  description = "Private key for SSH connection test"
  default     = "~/.ssh/id_ed25519"
}
