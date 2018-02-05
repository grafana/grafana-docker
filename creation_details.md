updating elasticsearch
Getting ecs role
1. go to iam -> Roles -> ecs-role-${env name}
2. take ecs-role role arn
3. modify elasticsearch access policy with something like:
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::729171034145:role/ecs-role-atb-stg-staging"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:us-east-1:729171034145:domain/atb-stg-es/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::729171034145:role/atb-stg-log-stream-lambda-role"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:us-east-1:729171034145:domain/atb-stg-es/*"
    }
  ]
}
4. update resource "aws_elasticsearch_domain_policy" "es_policy" to the above policy

5. create environment ini file
6. under [server] update to what the url will be
7. under [database]
    7.a needs to be one per environment
    7.b should be multiple zone
    7.c should have grafana-name space in identifyers
    7.d select environment vpc
    7.e select pre existing RDS security group
    7.d rotate postgres settings to match new postgres config
8. change admin password (CANNOT HAVE SPECIAL CHARACTERS :((((((((()
9. change secret key (CANNOT HAVE SPECIAL CHARACTERS :((((((((()
10. namespace cookie name
11. build container using ./build.sh PROJECT_NAME
12. make sure container boots using ./custom_start.sh PROJECT_NAME
13. make grafana service in ops repo. example:
    13.a run this: `NAME=atb-uat PROFILE=atb REGION=us-east-1 ENV=uat SRC=web DEST=grafana make service`
    13.b then update grafana port to 3034 in build/grafana/main.tf
14. deploy with 1 service to scaffold the infrastructure
    14.a `NAME=atb-uat PROFILE=atb REGION=us-east-1 ENV=uat MODULE=grafana make service-plan` (use any values, 1 instance)
    14.b `NAME=atb-uat PROFILE=atb REGION=us-east-1 ENV=uat MODULE=grafana make service-apply` (use any values, 1 instance)
15. change health check to /api/health
16. create aws IAM user with read permissions to cloudwatch (there should be some preexisting cloudwatch read group)
    14.a if cloudwatch read group doesn't exist, MAKE IT
17. deploy the grafana image you built minutes ago. check `docker images | grep grafana` to see what the TAG below should be
    17.a REPO=729171034145.dkr.ecr.us-east-1.amazonaws.com/grafana-atb-uat:0.0.1 TAG=atb-uat-grafana/grafana:master make tag
    17.b re-run the plan/apply commands above but this time use the real docker image tag
18. Add aws IAM datasource
19. Add elasticsearch data source
20. BONUS - port finn app grafan dashboard into customer