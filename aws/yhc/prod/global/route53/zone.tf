provider "aws" {
  region = "ap-northeast-2"
}

module "zones" {
    source = "../../../../../modules/zones"

    # private zone should have specific vpc
    zones = {
        "example.com" = {
            comment = "example.com",
            tags = {
                name = "example.com"
            }
        }
    }
}