#! /usr/bin/env bash
set -u
###############################################################################
# Description: ##### API Helm action handler.
# Creator: Bradley Carter
# Date: 10 Jun 2021
###############################################################################

#########################################
# Input Variables from Jenkins Job
#########################################
REGION=$1
ENV_NAME=$2
ACTION=$3
APP=$4
TAG=$5

#########################################
# Ascii colour codes (colourised Jenkins output)
#########################################
red='\033[0;31m'
green='\033[0;32m'
cyan='\033[0;36m'
reset='\033[0m' 
#########################################


#########################################
# Generate RG_CODE (infra region identifier)
#########################################
echo "detecting environment..."
if [[ "$REGION" == "us-east-2" ]]; then
    RG_CODE="oh"  # Ohio
elif [[ "$REGION" == "us-east-1" ]]; then
    RG_CODE="va" # US East (N. Virginia)
elif [[ "$REGION" == "us-west-1" ]]; then
    RG_CODE="ca" # N. California
elif [[ "$REGION" == "us-west-2" ]]; then
    RG_CODE="or" # US West (Oregon)
elif [[ "$REGION" == "ap-east-1" ]]; then
    RG_CODE="hk" # Hong Kong
elif [[ "$REGION" == "ap-south-1" ]]; then
    RG_CODE="mb" # Asia Pacific (Mumbai)
elif [[ "$REGION" == "ap-northeast-3" ]]; then
    RG_CODE="os" # Osaka-Local
elif [[ "$REGION" == "ap-northeast-2" ]]; then
    RG_CODE="se" # Asia Pacific (Seoul)
elif [[ "$REGION" == "ap-southeast-1" ]]; then
    RG_CODE="sg" # Singapore
elif [[ "$REGION" == "ap-southeast-2" ]]; then
    RG_CODE="sd" # Asia Pacific (Sydney) 
elif [[ "$REGION" == "ap-northeast-1" ]]; then
    RG_CODE="tk" # Tokyo 
elif [[ "$REGION" == "ca-central-1" ]]; then
    RG_CODE="cn" # Canada (Central)
elif [[ "$REGION" == "eu-central-1" ]]; then
    RG_CODE="ff" # Frankfurt
elif [[ "$REGION" == "eu-west-1" ]]; then
    RG_CODE="ie" # Europe (Ireland)
elif [[ "$REGION" == "eu-west-2" ]]; then
    RG_CODE="ld" # London
elif [[ "$REGION" == "eu-west-3" ]]; then
    RG_CODE="pr" # Europe (Paris) 
elif [[ "$REGION" == "eu-north-1" ]]; then
    RG_CODE="st" # Stockholm
elif [[ "$REGION" == "me-south-1" ]]; then
    RG_CODE="bh" # Middle East (Bahrain)
elif [[ "$REGION" == "sa-east-1" ]]; then
    RG_CODE="sp" # São Paulo 
else
    echo "Unknown Region" && exit 1
fi
#########################################

####################################################################################
# API Calls
####################################################################################
echo "authenticating with the cluster..."
aws eks update-kubeconfig \
    --region ${REGION} \
    --name ########### \
    --profile ############ \
    && chmod 600 ~/.kube/config
helm version

echo "fetching release info.."
STATUS=$(
    helm list -A     | 
    grep ${APP}      | 
    grep ${ENV_NAME} | 
    awk '{print $8}' | 
    tail -n1
)

NS=$(
    helm list -n ${ENV_NAME} | 
    grep ${ENV_NAME}         | 
    head -n1
)

echo "fetching ${APP} ECR info..."
ECR_URI=$(
    aws ecr describe-repositories    \
        --profile ########### \
        --region ${REGION}           \
        --query repositories[*].repositoryUri | 
        grep ${APP}  | 
        sed 's/"//g' | 
        sed 's/,//g' | 
        sed 's/ //g'
)


echo "ECR URI: ${ECR_URI}"
echo "Latest Tag: ${LATEST_TAG}"


echo "fetching RDS info..."
MARIADB_HOST=$(
    aws rds describe-db-instances \
        --profile ######## \
        --region ${REGION}        \
        --db-instance-identifier ############### \
        --query DBInstances[0].Endpoint.Address | 
        sed 's/"//g'
)

MARIADB_PASS=$(
    aws secretsmanager get-secret-value \
        --profile ############              \
        --region ${REGION}              \
        --secret-id ############### \
        --query SecretString \
        --output text  | 
        jq '.###_password' | 
        sed 's/"//g'
)

MARIADB_USER=$(
    aws secretsmanager get-secret-value \
        --profile #####-${ENV_NAME}       \
        --region ${REGION}              \
        --secret-id #####-${ENV_NAME}-${RG_CODE}-rds-#####connect-mariadb-credentials-v1 \
        --query SecretString \
        --output text  | 
        jq '.#####_username' | 
        sed 's/"//g'
)
echo ${MARIADB_HOST} ${MARIADB_PASS} ${MARIADB_USER} > /dev/null

echo "fetching mongoDB info..."
MONGODB_IP=$(
    aws ec2 describe-instances    \
        --profile #####-${ENV_NAME} \
        --region ${REGION}        \
        --filters "Name=tag:Name,Values=#####-${ENV_NAME}-${RG_CODE}-ec2-mongodb" \
        --query "Reservations[*].Instances[*].PrivateIpAddress" |
        grep [0-9].* | 
        sed 's/"//g' | 
        sed 's/ //g'
)
echo -e "mongoDB EC2 Instance IP: ${MONGODB_IP}\n"

####################################################################################
# DNS
####################################################################################
echo "compiling ALL service DNS addresses..."
DNS_SUFFIX="svc.cluster.local"

CONNECTWEB_SVC_DNS="connectweb.${ENV_NAME}.${DNS_SUFFIX}"
CONNECTGROUPS_SVC_DNS="connectgroups.${ENV_NAME}.${DNS_SUFFIX}"
CONNECTMAILER_SVC_DNS="connectmailer.${ENV_NAME}.${DNS_SUFFIX}"
CONNECTPAYMENTS_SVC_DNS="connectpayments.${ENV_NAME}.${DNS_SUFFIX}"
CONNECTREPORTS_SVC_DNS="connectreports.${ENV_NAME}.${DNS_SUFFIX}"
CONNECTSOCIAL_SVC_DNS="connectsocial.${ENV_NAME}.${DNS_SUFFIX}"

echo -e "ConnectWeb Service Address: ${CONNECTWEB_SVC_DNS}\n\n"
echo -e "ConnectGroups Service Address: ${CONNECTGROUPS_SVC_DNS}\n\n"
echo -e "ConnectMailer Service Address: ${CONNECTMAILER_SVC_DNS}\n\n"
echo -e "ConnectPayments Service Address: ${CONNECTPAYMENTS_SVC_DNS}\n\n"
echo -e "ConnectReports Service Address: ${CONNECTREPORTS_SVC_DNS}\n\n"
echo -e "ConnectSocial Service Address: ${CONNECTSOCIAL_SVC_DNS}\n\n"

RABBITMQ_SVC_DNS="rabbitmq-amqpclient.${ENV_NAME}.${DNS_SUFFIX}"
HTTPD_SVC_DNS="httpd-http.${ENV_NAME}.${DNS_SUFFIX}"
KAFKA_SVC_DNS="kafka.${ENV_NAME}.${DNS_SUFFIX}"
LICENSESVC_SVC_DNS="licence-service.${ENV_NAME}.${DNS_SUFFIX}"
AUTHSVC_SVC_DNS="auth-service.${ENV_NAME}.${DNS_SUFFIX}"
COREAPI_SVC_DNS="core-api.${ENV_NAME}.${DNS_SUFFIX}"
MEMBERAPI_SVC_DNS="member-api.${ENV_NAME}.${DNS_SUFFIX}"
SESSIONSVC_SVC_DNS="session-service.${ENV_NAME}.${DNS_SUFFIX}"
NOTIFICATIONSVC_SVC_DNS="notification-service.${ENV_NAME}.${DNS_SUFFIX}"
PDFSVC_SVC_DNS="pdfservice.${ENV_NAME}.${DNS_SUFFIX}"
MONGOSVC_SVC_DNS="mongoservice.${ENV_NAME}.${DNS_SUFFIX}"
ONLINE_APP_SVC_SVC_DNS="online-application-service.${ENV_NAME}.${DNS_SUFFIX}"
PRICING_ENGINE_SVC_DNS="pricing-engine.${ENV_NAME}.${DNS_SUFFIX}"
DISCOVERYSVC_SVC_DNS="discovery-service.${ENV_NAME}.${DNS_SUFFIX}"
APIBROKER_SVC_DNS="api-broker.${ENV_NAME}.${DNS_SUFFIX}"
VISITORSVC_SVC_DNS="visitor-service.${ENV_NAME}.${DNS_SUFFIX}"

echo -e "\n\nRabbit MQ Service Address: ${RABBITMQ_SVC_DNS}\n\n"
echo -e "Apache Service Address: ${HTTPD_SVC_DNS}\n\n"
echo -e "LicenseService Service Address: ${LICENSESVC_SVC_DNS}\n\n"
echo -e "AuthService Service Address: ${AUTHSVC_SVC_DNS}\n\n"
echo -e "CoreApi Service Address: ${COREAPI_SVC_DNS}\n\n"
echo -e "MemberApi Service Address: ${MEMBERAPI_SVC_DNS}\n\n"
echo -e "SessionService Servcie Address: ${SESSIONSVC_SVC_DNS}\n\n"
echo -e "NotificationService Service Address: ${NOTIFICATIONSVC_SVC_DNS}\n\n"
echo -e "PDFService Service Address: ${PDFSVC_SVC_DNS}\n\n"
echo -e "MongoService Service Address: ${MONGOSVC_SVC_DNS}\n\n"
echo -e "OnlineApplicationService Service Address: ${ONLINE_APP_SVC_SVC_DNS}\n\n"
echo -e "PricingEngine Service Address: ${PRICING_ENGINE_SVC_DNS}\n\n"
echo -e "ApiBroker Service Address: ${APIBROKER_SVC_DNS}\n\n"


####################################################################################
# Status Handler
####################################################################################
cd connect/helm
case $STATUS in    
    "unknown")
        echo -e "${red}release state unknown, cannot deploy${reset}"                               && \
        exit 1
        ;;
    "superseded")
        echo -e "${red}previous install has already been superseded, cannot deploy${reset}"        && \
        exit 1
        ;;
    "failed")
        echo -e "${red}previous install failed, please check release state${reset}"                && \
        exit 1
        ;;
    "uninstalling")
        echo -e "${red}previous install is still uninstalling, cannot deploy${reset}"              && \
        exit 1
        ;;
    "pending-install")
        echo -e "${red}previous install still incoming, cannot deploy${reset}"                     && \
        exit 1
        ;;
    "pending-upgrade")
        echo -e "${red}previous install pending update, cannot install${reset}"                    && \
        exit 1
        ;;
    "pending-rollback")
        echo -e "${red}previous install pending rollback, cannot install${reset}"                  && \
        exit 1
        ;;
    "uninstalled")
        echo -e "${red}this release has just been uninstalled, please check release state${reset}" && \
        exit 1
        ;;

####################################################################################
# Helm actions - When not installed.
####################################################################################

    "")
        if [[ ${NS} == "" && ${ACTION} == "install" ]]; then
            echo "no namespace detected, appending to installation.."
            helm install ${APP} -n ${ENV_NAME}                                                          \
                                --create-namespace                                                      \
                                --set-string region=${REGION}                                           \
                                --set-string envName=${ENV_NAME}                                        \
                                --set-string ecrUri=${ECR_URI}                                          \
                                --set-string image.tag=${LATEST_TAG}                                    \
                                --set-string mongo.host=${MONGODB_IP}                                   \
                                --set-string mariadb.host=${MARIADB_HOST}                               \
                                --set-string mariadb.user=${MARIADB_USER}                               \
                                --set-string mariadb.pass=${MARIADB_PASS}                               \
                                --set-string connectWeb.address=${CONNECTWEB_SVC_DNS}                   \
                                --set-string connectGroups.address=${CONNECTGROUPS_SVC_DNS}             \
                                --set-string connectMailer.address=${CONNECTMAILER_SVC_DNS}             \
                                --set-string connectPayments.address=${CONNECTPAYMENTS_SVC_DNS}         \
                                --set-string connectReports.address=${CONNECTREPORTS_SVC_DNS}           \
                                --set-string connectSocial.address=${CONNECTSOCIAL_SVC_DNS}             \
                                --set-string rabbitMq.address=${RABBITMQ_SVC_DNS}                       \
                                --set-string httpd.address=${HTTPD_SVC_DNS}                             \
                                --set-string kafka.address=${KAFKA_SVC_DNS}                             \
                                --set-string licenseService.address=${LICENSESVC_SVC_DNS}               \
                                --set-string authorisationService.address=${AUTHSVC_SVC_DNS}            \
                                --set-string coreApi.address=${COREAPI_SVC_DNS}                         \
                                --set-string memberApi.address=${MEMBERAPI_SVC_DNS}                     \
                                --set-string sessionServiceNode.address=${SESSIONSVC_SVC_DNS}           \
                                --set-string notificationService.address=${NOTIFICATIONSVC_SVC_DNS}     \
                                --set-string pdfService.address=${PDFSVC_SVC_DNS}                       \
                                --set-string mongoService.address=${MONGOSVC_SVC_DNS}                   \
                                --set-string onlineApplicationService.address=${ONLINE_APP_SVC_SVC_DNS} \
                                --set-string pricingEngine.address=${PRICING_ENGINE_SVC_DNS}            \
                                --set-string discoveryService.address=${DISCOVERYSVC_SVC_DNS}           \
                                --set-string visitorService.address=${VISITORSVC_SVC_DNS}               \
                                --set-string apiBroker.address=${APIBROKER_SVC_DNS}                     \
                                "${APP}/"        
        
        elif [[ ${ACTION} == "install" ]]; then
            echo "installing ${APP}..."
            helm install ${APP} -n ${ENV_NAME}                                                          \
                                --set-string region=${REGION}                                           \
                                --set-string envName=${ENV_NAME}                                        \
                                --set-string ecrUri=${ECR_URI}                                          \
                                --set-string image.tag=${LATEST_TAG}                                    \
                                --set-string mongo.host=${MONGODB_IP}                                   \
                                --set-string mariadb.host=${MARIADB_HOST}                               \
                                --set-string mariadb.user=${MARIADB_USER}                               \
                                --set-string mariadb.pass=${MARIADB_PASS}                               \
                                --set-string connectWeb.address=${CONNECTWEB_SVC_DNS}                   \
                                --set-string connectGroups.address=${CONNECTGROUPS_SVC_DNS}             \
                                --set-string connectMailer.address=${CONNECTMAILER_SVC_DNS}             \
                                --set-string connectPayments.address=${CONNECTPAYMENTS_SVC_DNS}         \
                                --set-string connectReports.address=${CONNECTREPORTS_SVC_DNS}           \
                                --set-string connectSocial.address=${CONNECTSOCIAL_SVC_DNS}             \
                                --set-string rabbitMq.address=${RABBITMQ_SVC_DNS}                       \
                                --set-string httpd.address=${HTTPD_SVC_DNS}                             \
                                --set-string kafka.address=${KAFKA_SVC_DNS}                             \
                                --set-string licenseService.address=${LICENSESVC_SVC_DNS}               \
                                --set-string authorisationService.address=${AUTHSVC_SVC_DNS}            \
                                --set-string coreApi.address=${COREAPI_SVC_DNS}                         \
                                --set-string memberApi.address=${MEMBERAPI_SVC_DNS}                     \
                                --set-string sessionServiceNode.address=${SESSIONSVC_SVC_DNS}           \
                                --set-string notificationService.address=${NOTIFICATIONSVC_SVC_DNS}     \
                                --set-string pdfService.address=${PDFSVC_SVC_DNS}                       \
                                --set-string mongoService.address=${MONGOSVC_SVC_DNS}                   \
                                --set-string onlineApplicationService.address=${ONLINE_APP_SVC_SVC_DNS} \
                                --set-string pricingEngine.address=${PRICING_ENGINE_SVC_DNS}            \
                                --set-string discoveryService.address=${DISCOVERYSVC_SVC_DNS}           \
                                --set-string visitorService.address=${VISITORSVC_SVC_DNS}               \
                                --set-string apiBroker.address=${APIBROKER_SVC_DNS}                     \
                                "${APP}/"
        else 
            echo -e "${red}Release not found, please choose the 'install' action first${reset}"
        fi
        ;;
####################################################################################
# Helm actions - When installed.
####################################################################################
    "deployed")
        if [[ ${ACTION} == "install" ]]; then
            echo "${APP} already installed, cannot proceed"
            exit 1

        elif [[ ${ACTION} == "upgrade" ]]; then
            echo "upgrading ${APP}..."
            helm upgrade -i ${APP} -n ${ENV_NAME}                                                          \
                                   --set-string region=${REGION}                                           \
                                   --set-string envName=${ENV_NAME}                                        \
                                   --set-string ecrUri=${ECR_URI}                                          \
                                   --set-string image.tag=${LATEST_TAG}                                    \
                                   --set-string mongo.host=${MONGODB_IP}                                   \
                                   --set-string mariadb.host=${MARIADB_HOST}                               \
                                   --set-string mariadb.user=${MARIADB_USER}                               \
                                   --set-string mariadb.pass=${MARIADB_PASS}                               \
                                   --set-string connectWeb.address=${CONNECTWEB_SVC_DNS}                   \
                                   --set-string connectGroups.address=${CONNECTGROUPS_SVC_DNS}             \
                                   --set-string connectMailer.address=${CONNECTMAILER_SVC_DNS}             \
                                   --set-string connectPayments.address=${CONNECTPAYMENTS_SVC_DNS}         \
                                   --set-string connectReports.address=${CONNECTREPORTS_SVC_DNS}           \
                                   --set-string connectSocial.address=${CONNECTSOCIAL_SVC_DNS}             \
                                   --set-string rabbitMq.address=${RABBITMQ_SVC_DNS}                       \
                                   --set-string httpd.address=${HTTPD_SVC_DNS}                             \
                                   --set-string kafka.address=${KAFKA_SVC_DNS}                             \
                                   --set-string licenseService.address=${LICENSESVC_SVC_DNS}               \
                                   --set-string authorisationService.address=${AUTHSVC_SVC_DNS}            \
                                   --set-string coreApi.address=${COREAPI_SVC_DNS}                         \
                                   --set-string memberApi.address=${MEMBERAPI_SVC_DNS}                     \
                                   --set-string sessionServiceNode.address=${SESSIONSVC_SVC_DNS}           \
                                   --set-string notificationService.address=${NOTIFICATIONSVC_SVC_DNS}     \
                                   --set-string pdfService.address=${PDFSVC_SVC_DNS}                       \
                                   --set-string mongoService.address=${MONGOSVC_SVC_DNS}                   \
                                   --set-string onlineApplicationService.address=${ONLINE_APP_SVC_SVC_DNS} \
                                   --set-string pricingEngine.address=${PRICING_ENGINE_SVC_DNS}            \
                                   --set-string discoveryService.address=${DISCOVERYSVC_SVC_DNS}           \
                                   --set-string visitorService.address=${VISITORSVC_SVC_DNS}               \
                                   --set-string apiBroker.address=${APIBROKER_SVC_DNS}                     \
                                   "${APP}/"

        elif [[ ${ACTION} == "rollback" ]]; then
            PREV_RELEASE_ID=$(
                helm history ${APP} -n ${APP} | 
                grep [0-9]       | 
                awk '{print $1}' | 
                sort -r          | 
                head -n2
            )
            echo "rolling back to release: ${PREV_RELEASE_ID}..."
            helm rollback ${APP} -n ${ENV_NAME} ${PREV_RELEASE_ID}
        
        elif [[ ${ACTION} == "uninstall" ]]; then
            echo "uninstalling ${APP}..."
            helm uninstall ${APP} -n ${ENV_NAME}
        else
            echo -e "${red}ACTION not found${reset}."
            exit 1
        fi
        ;;
esac
