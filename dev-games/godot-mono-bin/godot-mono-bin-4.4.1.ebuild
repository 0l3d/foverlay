# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Binary release of Godot Engine ${PV} with Mono (C#) support"
HOMEPAGE="https://godotengine.org"
SRC_URI="https://github.com/godotengine/godot-builds/releases/download/${PV}-stable/Godot_v${PV}-stable_mono_linux_x86_64.zip -> godot-mono-${PV}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gui"

DEPEND="app-arch/unzip"
RDEPEND="
	dev-dotnet/dotnet-sdk-bin
	media-libs/freetype
	sys-libs/zlib
"

S="${WORKDIR}"

src_unpack() {
	unpack godot-mono-${PV}.zip
}

src_install() {
	insinto /opt/godot-mono
	doins -r Godot_v${PV}-stable_mono_linux_x86_64/*


	chmod +x /opt/godot-mono/Godot_v${PV}-stable_mono_linux_x86_64

	# Binary için sembolik link oluştur
	dosym /opt/godot-mono/Godot_v${PV}-stable_mono_linux.x86_64 /usr/bin/godot-mono

	if use gui; then
		#newicon Godot_v${PV}-stable_mono_linux_x86_64/icon.svg godot-mono.svg
		make_desktop_entry godot-mono "Godot Engine (Mono)" godot-mono "Development;IDE;"
	fi
}
