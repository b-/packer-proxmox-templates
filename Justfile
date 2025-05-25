list:
    just --list
init:
    ./packer init -upgrade ubuntu-25.04-amd64
u2504: init
    cd ubuntu-25.04-amd64 && ../packer build -var-file=ubuntu-25.04.pkrvars.hcl .
docker: init
    cd docker-ubuntu-25.04-amd64 && ../packer build -var-file=ubuntu-25.04.pkrvars.hcl .

meta-u2504: init
    cd meta-ubuntu-amd64 && ../packer build -var-file=ubuntu-25.04.pkrvars.hcl .
