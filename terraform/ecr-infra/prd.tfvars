# ### Common variables
region      = "us-east-1" /* AWS region to deploy  */
environment = "" /* Specify the environment as 3 letter code - dev/stg/prd/tst/emg */
project     = "" /* Project name for which infra is built */ #

# Assume Role Variables
account_id  = ""
assume_role = ""
external_id = ""


## ECR - cron-service
cron_service_name = "cron-service"

## ECR - mongo-service
mongo_service_name = "mongo-service"

## ECR - swagger-docs
swagger_docs_name = "swagger-docs"

## ECR - document-service
document_service_name = "document-service"

## ECR - httpd
httpd_name = "httpd"

## ECR - kafka
kafka_name = "kafka"

## ECR - liquibase-artefacts
liquibase_artefacts_name = "liquibase-artefacts"

## ECR - liquibase
liquibase_name = "liquibase"

## ECR - memcached
memcached_name = "memcached"

## ECR - pdf-service-templates
pdf_service_templates_name = "pdf-service-templates"

## ECR - pdf-service
pdf_service_name = "pdf-service"

## ECR - notification-service
notification_service_name = "notification-service"

## ECR - php
php_name = "php"

## ECR - rabbit-manager
rabbit_manager_name = "rabbit-manager"

## ECR - zookeeper
zookeeper_name = "zookeeper"

## ECR - connect-cron
connect_cron_name = "connect-cron"

## ECR - connect-mailer
connect_mailer_name = "connect-mailer"

## ECR - connect-groups
connect_groups_name = "connect-groups"

## ECR - connect-social
connect_social_name = "connect-social"

## ECR - connect-reports
connect_reports_name = "connect-reports"

## ECR - connect-payments
connect_payments_name = "connect-payments"

## ECR - connect-web
connect_web_name = "connect-web"

## ECR - marketo
marketo_name = "marketo-connector-service"
