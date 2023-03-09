export FLEXE_SHELL_CONFIG="${HOME}/.flexe-tooling/shell-configs"

source ${FLEXE_SHELL_CONFIG}/autoupdate-helpers.sh
autoupdate-flexe-tooling

source ${FLEXE_SHELL_CONFIG}/common-helpers.sh
source ${FLEXE_SHELL_CONFIG}/nonprod-cluster-helpers.sh
source ${FLEXE_SHELL_CONFIG}/prod-cluster-helpers.sh
source ${FLEXE_SHELL_CONFIG}/kustomize-aliases.bash
source ${FLEXE_SHELL_CONFIG}/argocd-helpers.zsh

# CDs
alias provisioner="cd ~/workspace/provisioner/"
alias prov="cd ~/workspace/provisioner/"
alias cdwarehouser="cd ~/workspace/argocd-pipelines/services/warehouser/base"
alias warehouser="cd ~/workspace/warehouser"
alias shipyard="cd ~/workspace/shipyard"
alias infrastructure="cd ~/workspace/infrastructure/"
alias argocd-pipelines="cd ~/workspace/argocd-pipelines/"

alias moms="momus"

alias rep="rm ./plan_output* -f; ./terraform_plan.sh"
alias tir="terraform init && rep"
alias tap="terraform apply planfile"
