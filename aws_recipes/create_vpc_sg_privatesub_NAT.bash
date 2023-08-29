#!/bin/bash

## Goal: Creation of VPC, SG, 2 Private Subnets and 1 NAT Gateway

## Step 0: Copy the AWS Credentials and set it up with the right region
## the below is a custom command. Refer to `manage_multiple_aws_accounts.bash` file in this folder
manage_multiple_aws_accounts --region ap-south-1


## Step 1: Create a VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specification ResourceType=vpc,Tags=[{Key=Name,Value=SecOpsVpc}] > create-vpc-command-output.json
vpc_id=$(cat create-vpc-command-output.json | jp -u 'Vpc.VpcId')

## Step 2: Create a Public Subnet
: '
- A subnet is a range of IP addresses in your VPC. 
- After creating a VPC, you can add one or more subnets in each Availability Zone.
- Keep in mind that CIDR blocks must be unique within a VPC, 
and they should not overlap with CIDR blocks of other VPCs or subnets. 
- However, this uniqueness requirement is scoped to each AWS region. 
- Different AWS regions can use the same CIDR blocks without issue, 
as they are isolated from each other in terms of networking. 
- This allows you to use familiar IP address ranges in multiple regions if needed.
'
aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.0.0/24 > create-public-subnet1-output.json
public_subnet_id=$(cat create-public-subnet1-output.json | jp -u 'Subnet.SubnetId')

## Step 3: Create a Route Table for Public Subnet
## A route table contains a set of rules, called routes, that are used to determine where network traffic from your subnet or gateway is directed.
aws ec2 create-route-table --vpc-id $vpc_id > route-table-public-subnet-op.json
public_sub_route_table_id=$(cat route-table-public-subnet-op.json | jp -u 'RouteTable.RouteTableId')

## step 4A: create internet gateway id
## An internet gateway is a virtual router that connects a VPC to the internet
aws ec2 create-internet-gateway > create-ig.json
ig_id=$(cat create-ig.json | jp -u 'InternetGateway.InternetGatewayId')

## Step 4B: Attach the internet gateway to the VPC
aws ec2 attach-internet-gateway --internet-gateway-id $ig_id --vpc-id $vpc_id


## Step 5: Create a Route in the Public Route Table
aws ec2 create-route --route-table-id $public_sub_route_table_id --destination-cidr-block 0.0.0.0/0 --gateway-id $ig_id > create-public-route.json

## Step 6: Associate Public Subnet with Public Route Table
aws ec2 associate-route-table --subnet-id $public_subnet_id --route-table-id $public_sub_route_table_id > associate-route-table.json

## Step 7: Create Private Subnets
aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.1.0/24 > private-subnet-1.json
private_subnet1_id=$(cat private-subnet-1.json | jp -u 'Subnet.SubnetId')
aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.2.0/24 > private-subnet-2.json
private_subnet2_id=$(cat private-subnet-2.json | jp -u 'Subnet.SubnetId')

## Step 8A: Create Elastic IP Addresses
aws ec2 allocate-address > elastic-ip-addresses.json
elastic_ip_allocated=$(cat elastic-ip-addresses.json | jp -u 'AllocationId')

## Step 8B: Create NAT Gateway
: '
0. You can use a **network address translation** (NAT) gateway to enable instances in a private subnet to connect to services outside your VPC 
but prevent such external services from initiating a connection with those instances. 
There are two types of NAT gateways: public and private.

1. A public NAT gateway enables instances in private subnets to connect to the internet 
but prevents them from receiving unsolicited inbound connections from the internet. 
You should associate an elastic IP address with a public NAT gateway and 
attach an internet gateway to the VPC containing it. 

**We need Public NAT gateway and we have already attached an internet gateway in Step 4**

2. A private NAT gateway (not required for us) enables instances in private subnets to connect to other VPCs or 
your on-premises network but prevents any unsolicited inbound connections from outside your VPC. 
You can route traffic from the NAT gateway through a transit gateway or a virtual private gateway.
'
aws ec2 create-nat-gateway --subnet-id $public_subnet_id --allocation-id $elastic_ip_allocated > create-NAT-gw.json
nat_gw_id=$(cat create-NAT-gw.json | jp -u 'NatGateway.NatGatewayId')

## Step 9: Create a Route Table for Private Subnets
aws ec2 create-route-table --vpc-id $vpc_id > private_route_table.json
private_sub_route_table_id=$(cat private_route_table.json | jp -u 'RouteTable.RouteTableId')

## Step 10: Create a Route in the Private Route Table
aws ec2 create-route --route-table-id $private_sub_route_table_id --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $nat_gw_id > private-route.json

## Step 11: Associate private subnets with private route table id
## the below commands just return true in a json
aws ec2 associate-route-table --subnet-id $private_subnet1_id --route-table-id $private_sub_route_table_id
aws ec2 associate-route-table --subnet-id $private_subnet2_id --route-table-id $private_sub_route_table_id

## Step 12: Get Default VPC Security Group ID
aws ec2 describe-security-groups > describe-sgs.json
sec_group_id=$(cat describe-sgs.json | jp -u "SecurityGroups[?VpcId=='$vpc_id'].GroupId | [0]")

## Step 13: 
aws ec2 describe-nat-gateways > describe-nat-gateways.json
nat_gw_public_ip=$(cat describe-nat-gateways.json | jp -u "NatGateways[0].NatGatewayAddresses[0].PublicIp")


## Step 14: Items we will need
echo "The VPC is: $vpc_id"
echo "The private subnet 1 id is: $private_subnet1_id"
echo "The private subnet 2 id is: $private_subnet2_id"
echo "The Security Group ID is: $sec_group_id"
echo "The NAT Gateway Public IP Address is: $nat_gw_public_ip"


## Step 15: Conclusion
: '
These steps create a VPC with 1 public subnet, 2 private subnets, and a NAT gateway. 
The public subnet uses an Internet Gateway for internet access, 
while the private subnets use the NAT gateway for outbound internet connectivity.

Use the $private_subnet1_id,$vpc_id, and $sec_group_id  in creation of Lambda Functions and RDS within VPC
Add the NAT Gateway Public IP address for all services that accesses Public Internet
'