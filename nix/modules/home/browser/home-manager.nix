{
	flake.modules.homeManager.firefox = {pkgs, ...}: {
		home.sessionVariables = {
			MOZ_USE_XINPUT2 = "1";
		};

		# Install Firefox without taking over the user's profile. Keep per-profile
		# preferences, extensions, bookmarks, and UI customization in Firefox itself.
		programs.firefox = {
			enable = true;

			# Use policies only for system-level behavior that Nix should own.
			# Avoid programs.firefox.profiles.*.settings/user.js here because those
			# are reapplied on each launch and can override manual Firefox changes.
			policies = {
				# about:policies#documentation

				DisableAppUpdate = true;
				DisableFirefoxStudies = true;
				DisableTelemetry = true;
				DisablePocket = true;
				DisplayBookmarksToolbar = "always";
				DontCheckDefaultBrowser = true;

				# Builtin Password Manager
				OfferToSaveLogins = false;
				PasswordManagerEnabled = false;

				FirefoxHome = {
					TopSites = false;
					SponsoredTopSites = false;
					Pocket = false;
					Stories = false;
					SponsoredPocket = false;
					SponsoredStories = false;
					Snippets = false;
					Locked = false;
				};

				FirefoxSuggest = {
					SponsoredSuggestions = false;
					ImproveSuggest = false;
					Locked = false;
				};

				Homepage = {
					StartPage = "previous-session";
				};

				UserMessaging = {
					ExtensionRecommendations = false;
					FeatureRecommendations = false;
					MoreFromMozilla = false;
					SkipOnboarding = true;
					UrlbarInterventions = false;
				};

				ExtensionSettings = {
					"sponsorBlocker@ajay.app" = {
						installation_mode = "normal_installed";
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
					};
					"jid1-MnnxcxisBPnSXQ@jetpack" = {
						installation_mode = "normal_installed";
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
					};
					"support@lastpass.com" = {
						installation_mode = "normal_installed";
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/lastpass-password-manager/latest.xpi";
					};
					"uBlock0@raymondhill.net" = {
						installation_mode = "normal_installed";
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
					};
					# TODO: Install trydactyl here
				};

				Preferences = {
					"browser.tabs.allowTabDetach" = {
						Value = false;
						Status = "locked";
					};
					"browser.newtabpage.activity-stream.telemetry" = {
						Value = false;
						Status = "default";
					};
					"browser.newtabpage.activity-stream.feeds.telemetry" = {
						Value = false;
						Status = "default";
					};
					"browser.ping-centre.telemetry" = {
						Value = false;
						Status = "default";
					};
					"datareporting.healthreport.uploadEnabled" = {
						Value = false;
						Status = "default";
					};
					"datareporting.policy.dataSubmissionEnabled" = {
						Value = false;
						Status = "default";
					};
					"toolkit.telemetry.enabled" = {
						Value = false;
						Status = "default";
					};
					"toolkit.telemetry.unified" = {
						Value = false;
						Status = "default";
					};
				};
			};

			profiles.default.bookmarks = {
				force = true;

				settings = [
					{
						name = "Bookmarks Toolbar";
						toolbar = true;
						bookmarks = [
							{
								name = "Search";
								url = "https://search.nixos.org/packages";
							}
							{
								name = "Clone Nixpkgs";
								url = "https://github.com/NixOS/nixpkgs/issues/423262";
							}
							{
								name = "Nixpkgs";
								url = "https://github.com/NixOS/nixpkgs/pulls";
							}
						];
					}
				];
			};

			profiles.default.search = {
				# force = true;
				# default = "Google";
				# privateDefault = "Google";

				engines = {
					# "Google" = {
					# 	urls = [
					# 		{
					# 			template = "https://www.google.com/search";
					# 			params = [
					# 				{
					# 					name = "q";
					# 					value = "{searchTerms}";
					# 				}
					# 			];
					# 		}
					# 	];
					# 	definedAliases = ["@g"];
					# };
					#
					# "DuckDuckGo" = {
					# 	urls = [
					# 		{
					# 			template = "https://duckduckgo.com/";
					# 			params = [
					# 				{
					# 					name = "q";
					# 					value = "{searchTerms}";
					# 				}
					# 			];
					# 		}
					# 	];
					# 	definedAliases = ["@ddg"];
					# };

					"Nix Packages" = {
						urls = [
							{
								template = "https://search.nixos.org/packages";
								params = [
									{
										name = "channel";
										value = "unstable";
									}
									{
										name = "query";
										value = "{searchTerms}";
									}
								];
							}
						];
						icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
						definedAliases = ["@np"];
					};

					"Nix Options" = {
						urls = [
							{
								template = "https://search.nixos.org/options";
								params = [
									{
										name = "channel";
										value = "unstable";
									}
									{
										name = "query";
										value = "{searchTerms}";
									}
								];
							}
						];
						icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
						definedAliases = ["@no"];
					};
				};
			};
		};
	};
}
