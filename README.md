# enterprize-tf-lab

>
Frontend-application AMI (create and instance > install dependency > setup application > create )
Backend-application AMI (create and instance > install dependency > setup application > create )

Keypair (1)
IAM user () 
    1- data-s3-keys (put,get)
    2- logs-s3-keys (put,get)
    3- uat-s3-keys (put,get,delete)


>
Ec2 app-instances (3-from-ami)
Security-group (ec2-sg, alb-sg, rds-sg)
Auto scaling group + launch template
Target group (2)
Loadbalancer (tg-listnerRules,asg)

>
rds + read-replica
s3 buckets (3)
acm cert

>
custom vpc 
    - private subnet (RDS)
    - public subnet


>private open-vpn (server in a vpc to connect private resorces)