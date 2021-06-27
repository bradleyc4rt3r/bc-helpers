# Securely handles credentials for jenkins k8s credentials plugin

set -u
#Builds the helm variable files for SSH and AWS credentials

decrypt(){ #src #dest
    gpg --quiet --batch --yes --decrypt \
        --passphrase="${GPG_KEY}" \
        --output $2 \
        creds/$1
}

enable_tabs(){
    # Save current file descriptors
    # Create new descriptor via sub shell function
    # Apply 2 spaces to any new line
    exec 3>&1
    exec 1> >(sed 's/^/  /')
}

disable_tabs(){
    # Revert back to old file descriptor
    exec 1>&3 3>&-
}

helm_template(){
   echo -e "$1: |\n$(enable_tabs && cat $2 && disable_tabs)\n" >> "${HOME}/credentials.yml"
}

helm_template_b64(){
   echo -e "$1: |\n$(enable_tabs && cat $2 | base64 && disable_tabs)\n" >> "${HOME}/credentials.yml"
}

echo "decrypting AWS credentials.."
mkdir -p "${HOME}/.aws"
decrypt "aws_credentials.gpg" "${HOME}/.aws/credentials"
decrypt "aws_config.gpg" "${HOME}/.aws/config"

echo "creating AWS helm template for Jenkins installation.."
helm_template_b64 "awsCredentials" "${HOME}/.aws/credentials"
helm_template_b64 "awsConfig" "${HOME}/.aws/config"

echo "decrypting SSH credentials.."
mkdir -p "${HOME}/.ssh"
decrypt "ssh_config.gpg" "${HOME}/.ssh/config"
decrypt "github_credentials.gpg" "${HOME}/.ssh/id_rsa_github" 
decrypt "gitlab_credentials.gpg" "${HOME}/.ssh/id_rsa_gitlab"

echo "creating SSH helm templates for Jenkins installation.."
helm_template_b64 "config" "${HOME}/.ssh/config"
helm_template_b64 "githubKey" "${HOME}/.ssh/id_rsa_github"
helm_template_b64 "gitlabKey" "${HOME}/.ssh/id_rsa_gitlab"


echo "debug..."
cat "${HOME}/credentials.yml"