{
	stdenv,
	lib,
	fetchFromGitHub,
	pkg-config,
	libx11,
	libxinerama,
	libxcursor,
}:
stdenv.mkDerivation rec {
	pname = "sxwm";
	version = "1.8";
	src =
		fetchFromGitHub {
			owner = "uint23";
			repo = "sxwm";
			rev = "v${version}";
			hash = "sha256-VYqgHv/qwx+a0xZXfYkGEvLifLpsMSGLD3O9wSENO+0=";
		};

	__structuredAttrs = true;
	strictdeps = true;

	buildInputs = [
		libx11
		libxcursor
		libxinerama
	];

	nativeBuildInputs = [
		pkg-config
	];

	postPatch = ''
		substituteInPlace Makefile \
		    --replace-fail "/usr/local" "$out"
	'';
}
