module "single_instance" {
  source = "../../../../modules/ec2"
  name = "pulling_single_instance"

  ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-arm64-gp2"
  instance_type = "t4g.small"
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnets_id_by_az["ap-northeast-2a"]
  # IAM 인스턴스 프로파일 생성
  create_iam_instance_profile = true
  iam_role_name               = "codedeploy-ec2-role"
  iam_role_description        = "IAM role for EC2 instance to work with CodeDeploy"

  # CodeDeploy 정책 연결
  iam_role_policies = {
    AmazonEC2RoleforAWSCodeDeploy = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
  }

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
              wget https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-21.0.2/graalvm-community-jdk-21.0.2_linux-aarch64_bin.tar.gz
              tar -xzf graalvm-community-jdk-21.0.2_linux-aarch64_bin.tar.gz
              mv graalvm-community-openjdk-21.0.2+13.1 /usr/lib/graalvm
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

              # Install Certbot
              amazon-linux-extras install epel -y
              yum install -y certbot python2-certbot-nginx

              # Create the Nginx configuration file for the domain
              cat <<EOT > /etc/nginx/conf.d/api.pulling.in.conf
              server {
                  listen 80;
                  server_name api.pulling.in;
                  location / {
                      proxy_pass http://localhost:8080;
                      proxy_set_header Host \$host;
                      proxy_set_header X-Real-IP \$remote_addr;
                      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto \$scheme;
                  }
              }
              EOT

              # Restart NGINX to apply changes
              systemctl restart nginx

              # Set up a cron job to attempt SSL certificate issuance every 5 minutes
              echo "*/5 * * * * root certbot --nginx -d api.pulling.in --non-interactive --agree-tos --email hyunchul.yang@gmail.com || true" | sudo tee -a /etc/crontab > /dev/null

              # Set up auto-renewal
              echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q" | sudo tee -a /etc/crontab > /dev/null
              EOF

  ######
  # eip
  ######

  create_eip = true
  eip_domain = "vpc"

  eip_tags = {
    name = "eip_for_clip_single_instance"
  }

  tags = {
    name = "clip"
    stack   = "prod"
    product = "pulling"
    managed = "terraform"
  }
}