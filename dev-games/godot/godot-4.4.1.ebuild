# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit desktop python-any-r1 flag-o-matic scons-utils shell-completion toolchain-funcs xdg

DESCRIPTION="Multi-platform 2D and 3D game engine with a feature-rich editor and optional Mono support"
HOMEPAGE="https://godotengine.org/"
SRC_URI="https://github.com/godotengine/godot/archive/${PV}-stable.tar.gz -> ${P}-stable.tar.gz"
S="${WORKDIR}/${P}-stable"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gui +tools debug alsa +dbus +fontconfig pulseaudio raycast speech +theora +udev +upnp wayland +webp vulkan +xvfb +mono test"

RESTRICT="test"
REQUIRED_USE="wayland? ( gui )"

RDEPEND="
	app-arch/brotli:=
	app-arch/zstd:=
	dev-libs/icu:=
	dev-libs/libpcre2:=[pcre32]
	media-libs/freetype[brotli,harfbuzz]
	media-libs/harfbuzz:=[icu]
	media-libs/libogg
	media-libs/libpng:=
	media-libs/libvorbis
	net-libs/mbedtls:3=
	net-libs/wslay
	sys-libs/zlib:=
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	fontconfig? ( media-libs/fontconfig )
	gui? (
		media-libs/libglvnd
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libxkbcommon
		tools? ( raycast? ( media-libs/embree:4 ) )
		vulkan? ( media-libs/vulkan-loader[X,wayland?] )
	)
	pulseaudio? ( media-libs/libpulse )
	speech? ( app-accessibility/speech-dispatcher )
	theora? ( media-libs/libtheora )
	tools? ( app-misc/ca-certificates )
	udev? ( virtual/udev )
	upnp? ( net-libs/miniupnpc:= )
	wayland? ( dev-libs/wayland gui-libs/libdecor )
	webp? ( media-libs/libwebp:= )
	mono? ( dev-dotnet/dotnet-sdk-bin )
	xvfb? ( x11-misc/xvfb-run )
"

DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	${PYTHON_DEPS}
	mono? ( dev-dotnet/nuget )
"

PATCHES=()

src_prepare() {
	default

	sed -E "/pkg-config/s/(mbedtls|mbedcrypto|mbedx509)/&3/g" \
		-i platform/linuxbsd/detect.py || die

	sed -i "s|pkg-config |$(tc-getPKG_CONFIG) |" platform/linuxbsd/detect.py || die

	rm -r thirdparty/{brotli,doctest,embree,freetype,graphite,harfbuzz,icu4c,libogg,libpng,libtheora,libvorbis,libwebp,mbedtls,miniupnpc,pcre2,wslay,zlib,zstd} || die
	ln -s -- "${ESYSROOT}"/usr/include/doctest thirdparty/ || die
}

src_compile() {
	filter-lto
	export BUILD_NAME=gentoo

	local scons_args=(
		AR="$(tc-getAR)" CC="$(tc-getCC)" CXX="$(tc-getCXX)"
		platform=linuxbsd
		dev_build=$(usex debug)
		progress=no
		verbose=yes
		system_certs_path="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt

		alsa=$(usex alsa)
		dbus=$(usex dbus)
		fontconfig=$(usex fontconfig)
		pulseaudio=$(usex pulseaudio)
		speechd=$(usex speech)
		udev=$(usex udev)
		vulkan=$(usex gui $(usex vulkan))
		wayland=$(usex wayland)
		x11=$(usex gui)

		builtin_brotli=no
		builtin_certs=no
		builtin_clipper2=yes
		builtin_embree=$(usex !gui yes $(usex !tools yes $(usex !raycast)))
		builtin_enet=yes
		builtin_freetype=no
		builtin_glslang=yes
		builtin_graphite=no
		builtin_harfbuzz=no
		builtin_icu4c=no
		builtin_libogg=no
		builtin_libpng=no
		builtin_libtheora=$(usex !theora)
		builtin_libvorbis=no
		builtin_libwebp=$(usex !webp)
		builtin_mbedtls=no
		builtin_miniupnpc=$(usex !upnp)
		builtin_msdfgen=yes
		builtin_openxr=yes
		builtin_pcre2=no
		builtin_recastnavigation=yes
		builtin_rvo2=yes
		builtin_wslay=no
		builtin_xatlas=yes
		builtin_zlib=no
		builtin_zstd=no

		module_mono_enabled=yes
		module_raycast_enabled=$(usex gui $(usex tools $(usex raycast)))
		module_theora_enabled=$(usex theora)
		module_upnp_enabled=$(usex upnp)
		module_webp_enabled=$(usex webp)

		debug_symbols=no
		lto=none
		optimize=custom
		use_static_cpp=no
		target=editor
	)

	if use mono; then
		scons_args+=(mono_glue=no)
	fi

	export HOME="${T}/fake_home"
	export SDL_VIDEODRIVER=dummy
	export SDL_AUDIODRIVER=dummy
	export XDG_RUNTIME_DIR="${T}/runtime"
	mkdir -p "${HOME}" "${XDG_RUNTIME_DIR}"

	escons "${scons_args[@]}"

	if use mono; then
		xvfb-run -s "-screen 0 1920x1080x24 -nolisten local" ./bin/godot.linuxbsd.editor.*.mono --generate-mono-glue modules/mono/glue || die
		python3 modules/mono/build_scripts/build_assemblies.py --godot-output-dir=./bin --godot-platform=linuxbsd

	fi
}

src_install() {
	newbin bin/godot* godot

	doman misc/dist/linux/godot.6
	dodoc AUTHORS.md CHANGELOG.md DONORS.md README.md

	if use gui; then
		newicon icon.svg godot.svg
		domenu misc/dist/linux/org.godotengine.Godot.desktop
		insinto /usr/share/metainfo
		doins misc/dist/linux/org.godotengine.Godot.appdata.xml
		insinto /usr/share/mime/packages
		doins misc/dist/linux/org.godotengine.Godot.xml
	fi

	# Shell completion
	newbashcomp misc/dist/shell/godot.bash-completion godot
	newfishcomp misc/dist/shell/godot.fish godot.fish
	newzshcomp misc/dist/shell/_godot.zsh-completion _godot
}
