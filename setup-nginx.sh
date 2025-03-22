sudo apt install -y nginx
sudo service nginx start 
aws s3 sync s3://${aws_s3.bucket.web_bucket.id}/webcontent/ /home/ec2-user/
