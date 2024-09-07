module "single_instance" {
  source = "../../../../modules/ec2"
  name = "pulling_single_instance"
  instance_type = "t2.small"
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnets_id_by_az["ap-northeast-2a"]

  user_data = <<-EOF
              #!/bin/bash
              # Update system
              yum update -y

              # Install NGINX
              amazon-linux-extras install nginx1 -y
              systemctl start nginx
              systemctl enable nginx

              # Install GraalVM Java 21
              cd /tmp
              wget https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.0.0/graalvm-ce-java21-linux-amd64-21.0.0.tar.gz
              tar -xzf graalvm-ce-java21-linux-amd64-21.0.0.tar.gz
              mv graalvm-ce-java21-21.0.0 /usr/lib/graalvm
              echo 'export PATH=/usr/lib/graalvm/bin:$PATH' >> /etc/profile
              echo 'export JAVA_HOME=/usr/lib/graalvm' >> /etc/profile
              source /etc/profile

              # Install CodeDeploy Agent
              yum install -y ruby wget
              cd /home/ec2-user
              wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
              chmod +x ./install
              ./install auto
              service codedeploy-agent start

              # Get and install Let's Encrypt certificate
              amazon-linux-extras install epel -y
              yum install -y certbot python2-certbot-nginx

              certbot --nginx -d api.pulling.in --non-interactive --agree-tos --email hyunchul.yang@gmail.com

              # Set up auto-renewal
              echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q" | sudo tee -a /etc/crontab > /dev/null

              # Restart NGINX to apply changes
              systemctl restart nginx
              EOF

  ######
  # eip
  ######

#   create_eip = true
#   eip_domain = data.terraform_remote_state.vpc.id

  tags = {
    stack   = "prod"
    product = "pulling"
    managed = "terraform"
  }
}