terraform {
  source = "${get_parent_terragrunt_dir()}/../modules/clm"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "tas-clm-demo"
    key            = "clm/${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    profile        = "ris-bussvcs-dev"
  }
}