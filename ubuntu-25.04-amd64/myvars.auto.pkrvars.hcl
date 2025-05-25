disk_storage_pool       = "zssd"
iso_storage_pool        = "zssd-files"
cloud_init_storage_pool = "zssd-files"
timezone                = "America/New_York"
network_bridge = "vmbr0"
#network_vlan_tag        = 999
http_interface          = "wlp0s20f3"

sockets = 1
cores   = 3
memory  = 4096

serials = [
    "socket"
]
