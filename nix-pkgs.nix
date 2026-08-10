{ inputs, lib, ... }:
{
	nixpkgs = {
		config.allowUnfreePredicate = pkg:
			builtins.elem (lib.getName pkg) [
				"aspell-dict-en-science"
				"terraform"
				"slack"
			];

		overlays = [
			inputs.emacs-overlay.overlay
			(final: prev:
				{
					# When we want "local" packages from the packages dir
					# kustomize = localpackagesForSystem.kustomize;
				}
			)
		];
	};
}
