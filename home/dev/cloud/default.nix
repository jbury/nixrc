{ pkgs, ... }: {
	imports = [
		./aws.nix
		./azure.nix
		./gcp.nix
	];

	config.jbury.nixrc.home.modules.dev.cloud = {
		aws.enable   = true;
		azure.enable = false;
		gcp.enable   = false;
	};

	config.programs = {
		kubecolor = {
			enable               = true;
			enableZshIntegration = true;
		};

	};

	config.home.packages = with pkgs; [
		# Kubernetes
		kubectl # Talk at my kubernet pls
		krew # Plugin manager
		kubernetes-helm # Bane of my existence
		kind # Local kluster
		kustomize # We don't mess with the kubectl-bundled version

		# Kubernetes-curious
		argocd # At least it's not Terraform running Helm running Kustomize...
		istioctl # /page networking-oncall "I'm getting a 503 can you take a look"
		skaffold # Local dev connected to a kubernet in the cloud

		certbot

		#TODO: I suspect the pkgs I'm using in home-manager is not getting the configs from flake.nix, so it's not seeing that terraform has an allowUnfreePredicate set.
		#terraform
		#terraform-docs
		#Also need to make sure to set up my plugin cache
		#export TF_PLUGIN_CACHE_DIR="${HOME}/.terraform.d/plugin-cache" #TODO: Dependency
	];

	config.home.shellAliases = {
		k = "kubectl";
		kc = "kubectl";
		kccc = "kubectl config current-context";

		tf = "terraform";
		tir = "terraform plan -var-file=secrets.tfvars -out=planfile";
		tap = "terraform apply planfile";
		tfp = "terraform plan";
		tfa = "terraform apply";
		tfw = "terraform workspace";
		tfws = "tfw select";
		tfwl = "tfw list";
		tfv = "terraform validate";
		tfdiff = "terraform show --json | jq '.resource_changes[] | select(.change.actions | index(\"no-op\") | not)'";
	};
}
