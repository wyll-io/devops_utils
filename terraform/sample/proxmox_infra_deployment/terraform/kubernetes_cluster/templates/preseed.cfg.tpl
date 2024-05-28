# DMZ
#
#source: https://www.debian.org/releases/bullseye/example-preseed.txt

#_preseed_V1
### Localization
d-i debian-installer/locale string fr_FR
d-i debian-installer/language string fr
d-i debian-installer/country string FR
d-i debian-installer/locale string fr_FR.UTF-8
d-i keyboard-configuration/xkb-keymap select fr
# d-i keyboard-configuration/toggle select No toggling

### Network configuration

d-i netcfg/choose_interface select auto

# Timeout
#d-i netcfg/link_wait_timeout string 10
#d-i netcfg/dhcp_timeout string 60
#d-i netcfg/dhcpv6_timeout string 60

# Static network configuration.
#d-i netcfg/get_ipaddress string 192.168.1.42
#d-i netcfg/get_netmask string 255.255.255.0
#d-i netcfg/get_gateway string 192.168.1.1
#d-i netcfg/get_nameservers string 192.168.1.1
#d-i netcfg/confirm_static boolean true
# IPv6 example
#d-i netcfg/get_ipaddress string fc00::2
#d-i netcfg/get_netmask string ffff:ffff:ffff:ffff::
#d-i netcfg/get_gateway string fc00::1
#d-i netcfg/get_nameservers string fc00::1
#d-i netcfg/confirm_static boolean true

d-i netcfg/get_hostname string {{ vm_name }}
d-i netcfg/get_domain string unassigned-domain # On verras
d-i hw-detect/load_firmware boolean true

### Network console
# Use the following settings if you wish to make use of the network-console
# component for remote installation over SSH. This only makes sense if you
# intend to perform the remainder of the installation manually.
#d-i anna/choose_modules string network-console
#d-i network-console/authorized_keys_url string http://10.0.0.1/openssh-key
#d-i network-console/password password r00tme
#d-i network-console/password-again password r00tme

# Mirror
d-i mirror/http/hostname string deb.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string


### Account setup
d-i passwd/root-login boolean true
d-i passwd/root-password password ${root_password}
d-i passwd/root-password-again password ${root_password}
d-i passwd/make-user boolean true
d-i passwd/user-fullname string ${ssh_username}
d-i passwd/username string ${ssh_username} 
d-i passwd/user-password password ${user_password}
d-i passwd/user-password-again password ${user_password}

### Clock and time zone setup
d-i clock-setup/utc boolean true
d-i time/zone string Europe/Paris
d-i time/zone string US/Eastern
d-i clock-setup/ntp boolean true
#d-i clock-setup/ntp-server string ntp.example.com

### Partitioning
## Partitioning example
# If the system has free space you can choose to only partition that space.
# This is only honoured if partman-auto/method (below) is not set.
#d-i partman-auto/init_automatically_partition select biggest_free

# Alternatively, you may specify a disk to partition. If the system has only
# one disk the installer will default to using that, but otherwise the device
# name must be given in traditional, non-devfs format (so e.g. /dev/sda
# and not e.g. /dev/discs/disc0/disc).
# For example, to use the first SCSI/SATA hard disk:
#d-i partman-auto/disk string /dev/sda
# In addition, you'll need to specify the method to use.
# The presently available methods are:
# - regular: use the usual partition types for your architecture
# - lvm:     use LVM to partition the disk
# - crypto:  use LVM within an encrypted partition
d-i partman-auto/method string lvm
d-i partman-auto-lvm/guided_size string max
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-md/device_remove_md boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-auto/choose_recipe select atomic

d-i partman-basicfilesystems/no_swap boolean true

d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
#d-i partman/mount_style select uuid
d-i partman-md/confirm boolean true


### Base system installation
d-i apt-setup/cdrom/set-first boolean fals
d-i apt-setup/non-free boolean true
d-i apt-setup/contrib boolean true
d-i apt-setup/disable-cdrom-entries boolean true
# Select which update services to use; define the mirrors to be used.
# Values shown below are the normal defaults.
d-i apt-setup/services-select multiselect security, updates
d-i apt-setup/security_host string security.debian.org

# Backports
#d-i apt-setup/local0/repository string \
#       http://local.server/debian stable main


### Package selection
#tasksel tasksel/first multiselect standard, web-server, kde-desktop

# Or choose to not get the tasksel dialog displayed at all (and don't install
# any packages):
#d-i pkgsel/run_tasksel boolean false

tasksel tasksel/first multiselect standard
d-i pkgsel/include string openssh-server build-essential vim wget curl rsync tree dnsutils sudo htop curl python3 python3-pip python3-apt net-tools gnupg2 hostname ansible qemu-guest-agent parted

d-i pkgsel/upgrade select full-upgrade

### Boot loader installation
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean false

#d-i grub-installer/bootdev  string /dev/sda
d-i grub-installer/bootdev  string default


d-i preseed/late_command string \
    in-target sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config; \
    in-target sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config; \
    in-target /bin/bash -c 'usermod -aG sudo ${ssh_username}';

d-i finish-install/reboot_in_progress note

