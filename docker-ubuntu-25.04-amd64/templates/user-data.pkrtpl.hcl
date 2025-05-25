#cloud-config
autoinstall:
  version: 1
  locale: ${locale}
  keyboard:
    layout: ${keyboard_layout}
  network:
    network:
      version: 2
      ethernets:
        mainif:
          match:
            name: e*
          critical: true
          dhcp4: true
          dhcp-identifier: mac
  ssh:
    install-server: true
    allow-pw: %{ if length(ssh_public_keys) > 0 }false%{ else }true%{ endif }
  codecs:
    install: false
  drivers:
    install: false
  packages:
    - qemu-guest-agent
%{ for package in cloud_init_apt_packages ~}
    - ${package}
%{ endfor ~}
  storage:
    layout:
      name: direct
    swap:
      size: 0
  late-commands:

    ## Set kernel cmd settings
    - sed -ie 's/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="console=tty0 console=ttyS0 net.ifnames=0 biosdevname=0"/' /target/etc/default/grub
    - sed -ie 's/GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/' /target/etc/default/grub
    - curtin in-target --target /target update-grub2

    ## Enable serial console
    - curtin in-target --target /target systemctl enable serial-getty@ttyS0.service

#    ## Install Docker
#    - curl -fsSL https://get.docker.com -o /target/tmp/get-docker.sh
#    - chmod +x /target/tmp/get-docker.sh
#    - curtin in-target --target /target /tmp/get-docker.sh
#    - rm /target/tmp/get-docker.sh
  updates: security
  user-data:
    package_upgrade: true
    disable_root: true
    timezone: ${ timezone }
    users:
      - name: ${ ssh_username }
        passwd: ${ ssh_password }
        groups: [adm, cdrom, dip, plugdev, lxd, sudo]
        lock-passwd: %{ if length(ssh_public_keys) > 0 }true%{ else }false%{ endif }
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
%{ if length(ssh_public_keys) > 0 ~}
        ssh_authorized_keys:
%{ for key in ssh_public_keys ~}
          - ${key}
%{ endfor ~}
%{ endif ~}
