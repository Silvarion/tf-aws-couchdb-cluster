# tf-couchdb: Terraform CouchDB Module

This module is intended to be as self contained as possible to create a CouchDB Cluster on AWS

## Assumptions
* There must be a CouchDB AMI created and available with a name starting with "couchdb-base"
* A cluster will be deployed, not a single instance

## Required Variables
* **cidr_blocks**: CIDR Blocks or networks to allow to connect to CouchDB from
* **data_ebs_size**: Size of additional EBS volume where CouchDB data will be stored
* **env**: Environment name/code (i.e.: dev)
* **key_name**: Key pair name to access the instances via SSH
* **owner**: Owner name or code for tagging the instances
* **vpc**: VPC in which the instances will run

## Usage