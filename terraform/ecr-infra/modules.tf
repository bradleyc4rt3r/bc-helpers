## ECR - ##########-api-broker
module "##########-api-broker" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.##########_api_broker_name
}

## ECR - ##########-auth2-server
module "##########-auth2-server" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.##########_auth2_server_name
}

## ECR - ##########-core-api
module "##########-core-api" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.##########_core_api_name
}

## ECR - ##########-license-service
module "##########-license-service" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.##########_license_service_name
}

## ECR - ##########-member-api
module "##########-member-api" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.##########_member_api_name
}

## ECR - ##########-online-application-service
module "##########-online-application-service" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.##########_online_application_service_name
}

## ECR - cron-service
module "cron-service" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.cron_service_name
}

## ECR - mongo-service
module "mongo-service" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.mongo_service_name
}

## ECR - swagger-docs
module "swagger-docs" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.swagger_docs_name
}

## ECR - document-service
module "document-service" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.document_service_name
}

## ECR - httpd
module "httpd" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.httpd_name
}

## ECR - kafka
module "kafka" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.kafka_name
}

## ECR - liquibase-artefacts
module "liquibase-artefacts" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.liquibase_artefacts_name
}

## ECR - liquibase
module "liquibase" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.liquibase_name
}

## ECR - memcached
module "memcached" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.memcached_name
}

## ECR - pdf-service-templates
module "pdf-service-templates" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.pdf_service_templates_name
}

## ECR - pdf-service
module "pdf-service" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.pdf_service_name
}

## ECR - notification-service
module "notification-service" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.notification_service_name
}

## ECR - php
module "php" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.php_name
}

## ECR - rabbit-manager
module "rabbit-manager" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.rabbit_manager_name
}

## ECR - zookeeper
module "zookeeper" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.zookeeper_name
}

## ECR - connect-cron
module "connect-cron" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.connect_cron_name
}

## ECR - connect-mailer
module "connect-mailer" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.connect_mailer_name
}

## ECR - connect-groups
module "connect-groups" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.connect_groups_name
}

## ECR - connect-social
module "connect-social" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.connect_social_name
}

## ECR - connect-reports
module "connect-reports" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.connect_reports_name
}

## ECR - connect-payments
module "connect-payments" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.connect_payments_name
}

## ECR - connect-web
module "connect-web" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.connect_web_name
}

## ECR - marketo
module "marketo" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.marketo_name
}

## ECR - railgun
module "railgun" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.railgun_name
}

## ECR - pricing-engine
module "pricing-engine" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.pricing_engine_name
}

## ECR - pricing/database
module "pricing-database" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.pricing_database_name
}

## ECR - jdk13 
module "jdk13" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.jdk13_name
}

## ECR - CMS Artefacts 
module "cms_artefacts" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.cms_artefacts_name
}

## ECR - redis 
module "redis" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.redis_name
}

## ECR - peregrinephp 
module "peregrinephp" {
  source         = "./modules/ecr"
  project_prefix = local.project_prefix
  environment    = var.environment
  region         = var.region
  ecr_name       = var.peregrinephp_name
}
