data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
subnet_id = module.vpc.public_subnets[0]
vpc_security_group_ids= [aws_security_group.allow_tls.id]
key_name = aws_key_pair.deployer.key_name
associate_public_ip_address  = true
  tags = {
    Name = "ebs_vol_testing"
  }

#   user_data = <<EOF
# #!/bin/bash
# echo "Attaching EBS volume to EC@"
# echo "Mount NFS"
# sudo mkfs.ext4 /dev/xvdh -y
# sudo mkdir /data
# #sudo mount /dev/xvdh /data
# sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_ebs_volume.example.id}:/  /data
# EOF
}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-west-1b"
  size              = 10

  tags = {
    Name = "HelloWorld"
  }
}

output "ip" {
  value = aws_instance.web.public_ip
  }

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.web.id
}

# resource "null_resource" "name" {
#     connection {
#         type = "ssh"
#      user = "ubuntu"
#      private_key = file("mykey")
#      host= aws_instance.web.public_ip
#     } 
#     provisioner "remote-exec" {
#       inline = [ 
#         "sudo mkfs.ext4 /dev/xvdh",
#         "sudo mkdir /data" ,
#         "sudo mount /dev/xvdh /data"
#         ]
#     }
# }
