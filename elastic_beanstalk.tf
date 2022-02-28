resource "aws_elastic_beanstalk_application" "backend_beanstalk_application" {
  name = "demo"
  description = "Demo app"
}

resource "aws_elastic_beanstalk_application_version" "backend_beanstalk_application_version" {
  application = aws_elastic_beanstalk_application.backend_beanstalk_application.name
  bucket = aws_s3_bucket.backend_bucket.id
  key = "aws-demo-backend-0.0.1-SNAPSHOT.jar"
  name = "aws-demo-backend-0.0.1-SNAPSHOT"
}

resource "aws_elastic_beanstalk_environment" "beanstalk_app_env" {
  name = "backend"
  application = aws_elastic_beanstalk_application.backend_beanstalk_application.name
  solution_stack_name = "64bit Amazon Linux 2 v3.2.11 running Corretto 11"
  version_label = aws_elastic_beanstalk_application_version.backend_beanstalk_application_version.name

  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "aws-elasticbeanstalk-ec2-role"
  }
}