# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Godot Engine with Mono (C#) support - binary release"
HOMEPAGE="https://godotengine.org"
SRC_URI="https://github.com/godotengine/godot/releases/download/${PV}-stable/Godot_v${PV}-stable_mono_linux_x86_64.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror strip"

RDEPEND="
	dev-dotnet/dotnet-sdk-bin
	media-libs/libsdl2
	sys-libs/zlib
	media-libs/libglvnd
"

DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	default
}

src_install() {
	local bindir="Godot_v${PV}-stable_mono_linux_x86_64"
	local binfile="Godot_v${PV}-stable_mono_linux.x86_64"

	dobin "${bindir}/${binfile}"

	mv "${D}/usr/bin/${binfile}" "${D}/usr/bin/godot-mono" || die

	make_desktop_entry "godot-mono" "Godot Engine (Mono)" "godot-mono" "Development;IDE;"
}

pkg_postinst() {
	elog "Godot Mono ${PV} has been installed."
	elog "You can run it using the command: godot-mono"
	elog "Make sure you have dotnet-sdk-bin installed for C# scripting support."
}
