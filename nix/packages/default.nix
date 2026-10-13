# This is an overlay
final: prev:
# Apply callPackage to every attr
builtins.mapAttrs
# We use final because we want the final package set, in case some derivations
# depend on other derivations
(_: v: final.callPackage v {})
# Filter out paths that don't exist
(prev.lib.filterAttrs
	# The `_` here is the key. The builtins.pathExists accepts the path
	# value. I should think about whether I want to raise a warning here
	# as well
	(_: builtins.pathExists)
	# Apply the function to every (key, value) in the the attr.
	# The function return becomes the new attribute value.
	(builtins.mapAttrs
		# Construct a path to the package.nix given the directory name
		(name: _: ./${name}/package.nix)
		# Filter out all non directory entries in the attr
		(prev.lib.filterAttrs
			# lambda function that accepts a attra key, value pair
			# and returns true if the value is "directory"
			(k: v: v == "directory")
			# Collects every folder and directory and returns an attr
			# with every folder/file labeled as directory or regular
			(builtins.readDir ./.))))
