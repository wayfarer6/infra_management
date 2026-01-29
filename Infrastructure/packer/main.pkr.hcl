packer {
    required_plugins { # virtualbox 를 이용해 vhd 만들 예정
        virtualbox = {
            version = ">= 1.0.0"
            source  = "github.com/hashicorp/virtualbox"
        }
    }
}

variable "rocky_iso_url" {
    type    = string
    default = "https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10-Minimal-x86_64-dvd1.iso"
}

variable "iso_checksum" {
    type    = string
    default = "3b5d5c6c8f1a4e9f4a3e2b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e"
}


source "virtualbox-iso" "rocky10" {
    iso_url      = var.rocky_iso_url
    iso_checksum = var.iso_checksum
    vm_name = "rocky10-{{timestamp}}-gold"
    guest_os_type = "RedHat_64" #virtualbox에 따로 rocky로 type이 없음. 

    cpus = 2
    memory = 2048
    disk_size   = 512000 # 최대 500gb 까지 확장 가능!
    use_fixed_vhd_format = false # 기본값은 false, 여기선 별도 명시


    ssh_username = "packer_user"
    ssh_password = "packerpassword"
    ssh_wait_timeout = "20m"

    boot_command = [
        "<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
    ] # kickstart 파일을 이용해 자동 설치

    boot_wait = "10s"
    http_directory = "http" # Kickstat(ks,cfg) 파일을 제공할 로컬 디렉토리 


    shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
}

build {

    sources = [
        "source.virtualbox-iso.rocky10"
    ]

    provisioner "shell" {
        inline = [
            "sudo dnf update -y",
            "sudo dnf install -y wget vim net-tools curl epel-release nano tar gzip",
            "sudo dnf clean all"
        ]
    }
}