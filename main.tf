# vpc , igw , route table public and private
module "vpc"  {
    source = "./network"
    vpc-cidr = "10.0.0.0/16"
    vpc-name = "terraform-vpc"

    igw-name = "terraform-internet-gate-way"

    nat-name = "terrform-nat"
    
    route-table-public-cidr = "0.0.0.0/0"
    route-table-public = "terraform-public-route-table" 
    route-table-private = "terraform-private-route-table"
    
    
    subnet-cidr = ["10.0.0.0/24","10.0.2.0/24"]
    subnet-name = ["terraform-public-subnet", "terraform-public-subnet-2"]
    availability-zone = ["us-east-1a","us-east-1b"]

    subnet-cidr-2 = [ "10.0.1.0/24", "10.0.3.0/24"]
    subnet-name-2 = ["terraform-private-subnet", "terraform-private-subnet-2"]
    availability-zone-2 = ["us-east-1a","us-east-1b"]

    security-group-name ="security-group-ssh-http"

}

# create 2 ec2 public and 2 ec2 private 
module "ec2" {
   source = "./ec2"
  
   ami-id = "ami-00874d747dde814fa" # ubuntu img
   security-group-id = module.vpc.security-group-id
   public-ec2-name = ["terraform-public-ec2","terraform-public-ec2-2"]
   public-subnet-id = [module.vpc.public-subnet-1, module.vpc.public-subnet-2]

   
   private-ec2-name = ["terraform-private-ec2","terraform-private-ec2-2"]
   private-subnet-id = [module.vpc.private-subnet-1, module.vpc.private-subnet-2]
   alb-private-dns-name = module.alb.alb-2-dns-name

}
module "alb" {
   source = "./loadbalancer"
   alb-tg-name = "public-alb-tg"
   alb-name = "terraform-public-alb"
   security-group-lb-name = "terraform_alb_security_group"
   vpc-id = module.vpc.my-vpc-id
   public-subnet-id-1 = module.vpc.public-subnet-1
   public-subnet-id-2 = module.vpc.public-subnet-2
   public-instance-ids =  [module.ec2.public-ec2-1,module.ec2.public-ec2-2]

   private-alb-name = "terraform-private-alb"
   private-alb-tg-name = "private-alb-tg"
   private-subnet-id-1 = module.vpc.private-subnet-1
   private-subnet-id-2 = module.vpc.private-subnet-2
   private-instance-ids = [module.ec2.private-ec2-1,module.ec2.private-ec2-2]
   
}


# output of module is input to another module
# vpc_id = module.az1.vpc_id
#         module.<module name>.<output name>