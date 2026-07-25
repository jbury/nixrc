{ inputs, config, lib, jbury-lib, ... }:

let
	inherit (lib) mkForce;
	inherit (lib.types) str;
	inherit (jbury-lib) mkOptDef mkBoolOptDef;

	cfg          = config.jbury.nixrc.hosts.templates.darwinHost;
	hostSettings = config.jbury.nixrc.hostSettings;

in {
	imports = [
		../.
		inputs.nixos-wsl.nixosModules.default
	];

	options.jbury.nixrc.hosts.templates.darwinHost = {
		userName = mkOptDef str hostSettings.userName;
		hostname = mkOptDef str hostSettings.hostname;

	};

	config = {
		#TODO for now, no desktop apps for Darwin.  I don't really want to find out what
		# sort of suffering awaits one that has installed apps with brew _and then_ nix.
		jbury.nixrc.hostSettings.hasDesktop = mkForce false;

		system = {
			stateVersion   = hostSettings.stateVersion;
			nixpkgsRelease = "26.11";
			startupChime   = false;
		};

		time.timeZone = hostSettings.timeZone;

		## Below here we're configuring nix-darwin stuff.
		networking = {
			computerName = cfg.hostname;
			hostName     = cfg.hostname;

			knownNetworkServices = [
				"ThinkPad TBT 3 Dock"
				"Thunderbolt Bridge"
				"WiFi"
			];

		};

		nix = {
			settings = {
				# Default is *, allowing _anyone_ to connect to the nix daemon.  Wut.
				allowed-users = [ ];

				# TODO: Going to have to mkForce this I think?
				trusted-users = [ "@admin" ];
			};
		};

		power = {
			sleep = {
				allowSleepByPowerButton = true;

				# Oddly named, but it's the time in minutes the machine needs to be idle before
				# the computer sleeps.
				computer = 10;

				# time in minutes the machine needs to be idle before displays sleep.
				display  = 5;
			};
		};

		# These are most of the Mac settings, and consistency or sane organization is apparently not on
		# the menu.  Instead SGlobalDomain is a String -> String grab bag of random settings, some attrs
		# are camelCase, some are PascalCase, some are all lowercase, and so many of them are
		# `Type: null or X` and they default to null, but then don't tell you what that even means.
		#
		# Presently, they're _all_ (mostly) TODO
		system.defaults = {
			SGlobalDomain = {
				# Mac settings not covereed below
			};

			WindowManager = {
				# Settings for StageManager
			};

			controlcenter = {
				# Settings for mac toolbar (clock/battery/bluetooth/etc.)
			};

			dock = {
				enable-spring-load-actions-on-all-items = false;
				appswitcher-all-displays                = true;
				autohide                                = false;
				dashboard-in-overlay                    = false;
				launchanim                              = false;
				magnification                           = false;
				minimize-to-application                 = false;
				mouse-over-hilite-stack                 = false;
				mru-spaces                              = false;
				orientation                             = "left";
				## This is a whole-ass thing that I don't want to figure out right now.
				#persistent-apps                         = TODO
				scroll-to-open                           = false;
				show-process-indicators                  = true;
				show-recents                             = false;
				showAppExposeGestureEnabled              = false;
				showDesktopGestureEnabled                = false;
				showLaunchpadGestureEnabled              = false;
				showMissionControlGestureEnabled         = false;
				showHidden                               = true;
				slow-motion-allowed                      = false;
				static-only                              = false; # I guess???  Doesn't this like...conflict with...other things?  idk.
				wvous-bl-corner                          = 1;
				wvous-br-corner                          = 1;
				wvous-tl-corner                          = 1;
				wvous-tr-corner                          = 1;
			};

			finder = {
				# Settings for the finder
			};

			# What "to do" when the function key is pressed, but like, totally separate from
			# having the function keys be function keys unless you hold fn, then they're the 
			# special media/brightness/whatever keys.
			hitoolbox.AppleFnUsageType = "Do Nothing";

			loginwindow = {
				# No, you may _not_ have a console by logging in as the magic ">console" username.
				# why is that even the default?
				DisableConsoleAccess = true;

				# No guests - don't you guys have phones?
				GuestEnabled = false;
			};

			# I can right click and left click with _one_ finger.
			# Wait is the just that weird mac mouse that you click the entire thing? I don't care about
			# that at all tbh.
			magicmouse.MouseButtonMode = "TwoButton";

			menuExtraClock = {
				ShowAMPM = true;

				# 1 = Always
				ShowDate       = 1;
				ShowDayOfMonth = true;
				ShowDayOfWeek  = true;
			};

			screencapture = {
				# TODO: Where screenshots should be saved
				# location = 
			};

			screensaver = {
				askForPassword = true;

				# Sometimes I'm preoccupied but I still don't want my machine screensavering.
				askForPasswordDelay = 10;
			};

			trackpad = {
				# 2 = bottom-right corner
				TrackpadCornerSecondaryClick = 2;

				TrackpadRightClick = true;

				# weeeeeeeeEEEEEEEEEEEEEEEeeeeeeeee
				TrackpadMomentumScroll = true;

				# Dear God, no gestures at all please.  Never. I don't care these are the 
				# defaults, I *never* want this.   
				TrackpadFourFingerHorizSwipeGesture        = 0;
				TrackpadFourFingerPinchGesture             = 0;
				TrackpadFourFingerVertSwipeGesture         = 0;
				TrackpadPinch                              = false;
				TrackpadRotate                             = false;
				TrackpadThreeFingerDrag                    = false;
				TrackpadThreeFingerHorizSwipeGesture       = 0;
				TrackpadThreeFingerTapGesture              = 0;
				TrackpadThreeFingerVertSwipeGesture        = 0;
				TrackpadTwoFingerDoubleTapGesture          = 0;
				TrackpadTwoFingerFromRightEdgeSwipeGesture = 0;
			};

			universalaccess = {
				closeViewScrollWheelToggle = false;
				closeViewZoomFollowsFocus  = false;
				mouseDriverCursorSize      = 1;
				reduceMotion               = true;
				reduceTransparency         = true;
			};

			keyboard = {
				enableKeyMapping               = false;
				remapTilde                     = false;
				remapCapsLockToControl         = false;
				remapCapsLockToEscape          = false;
				swapCapsLockAndEscape          = false;
				swapLeftCommandAndLeftAlt      = false;
				swapLeftCtrlAndFn              = false;
				swapRightCommandAndRightOption = false;
			};
