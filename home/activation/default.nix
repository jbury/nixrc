{ ... }: {
	imports = [
		./git-keys.nix
	];

	config.jbury.nixrc.home.modules.activation = {
		#TODO Non-password-protected git keys are no bueno
		# Disable auto key generation til I fix that
		git-keys.enable = false;
	};
}
