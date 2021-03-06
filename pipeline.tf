provider "aws" {
  region   = "ap-south-1"
  profile  = "shailly_shah"
}

resource "aws_codepipeline" "githubb" {
name = "githubb"
role_arn =
"arn:aws:iam::926649******:role/service-role/AWSCodePipelineSer
viceRole-ap-south-1-githubb"
artifact_store {
location =
"${aws_s3_bucket.my-test-s3-terraform-bucket-shaillys3.bucket}"
type = "S3"
}
stage {
name = "Source"
action {
name = "Source"
category = "Source"
owner = "ThirdParty"
provider = "GitHub"
version = "1"
output_artifacts = ["SourceArtifacts"]
configuration = {
Owner = "Shailly29"
Repo = "hybrid-task1"
Branch = "master"
OAuthToken = "07078fc5ba0b216b1765138085***************"
PollForSourceChanges = "true"
}
}
}
stage {
name = "Deploy"
action {
name = "Deploy"
category = "Deploy"
owner = "AWS"
provider = "S3"
input_artifacts = ["SourceArtifacts"]
version = "1"
configuration = {
"BucketName" = "my-test-s3-terraform-bucket-shaillys3"
"Extract" = "true"
}
}
}
}