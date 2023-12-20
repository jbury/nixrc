export FLEXE_TOOLING_DIR="${HOME}/.flexe-tooling"
export FLEXE_SHELL_CONFIG="${FLEXE_TOOLING_DIR}/shell-configs"
export FLEXE_TOOLING_VERBOSE="true"

source ${FLEXE_SHELL_CONFIG}/autoupdate-helpers.sh
autoupdate-flexe-tooling

source ${FLEXE_SHELL_CONFIG}/common-helpers.sh
source ${FLEXE_SHELL_CONFIG}/nonprod-cluster-helpers.sh
source ${FLEXE_SHELL_CONFIG}/prod-cluster-helpers.sh
source ${FLEXE_SHELL_CONFIG}/kustomize-aliases.bash
source ${FLEXE_SHELL_CONFIG}/argocd-helpers.sh

alias kb="kustbuild"
alias kbd="kustdiff"
alias kbp="kustprint"
alias kbad="kustapply"

# CDs
alias provisioner="cd ~/workspace/provisioner/"
alias prov="cd ~/workspace/provisioner/"
alias cdwarehouser="cd ~/workspace/argocd-pipelines/services/warehouser/base"
alias warehouser="cd ~/workspace/warehouser"
alias shipyard="cd ~/workspace/shipyard"
alias infrastructure="cd ~/workspace/infrastructure/"
alias argocd-pipelines="cd ~/workspace/argocd-pipelines/"

alias moms="momus"

alias terraflexe="~/workspace/terraflexe/terraflexe"
alias tf="terraflexe"
alias tir="tf p"
alias tap="terraform apply planfile"

