# Copyright 2025
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Godot Engine ${PV} Mono version (prebuilt binary)"
HOMEPAGE="https://godotengine.org"
SRC_URI="https://github.com/godotengine/godot/releases/download/${PV}-stable/Godot_v${PV}-stable_mono_linux_x86_64.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-dotnet/dotnet-sdk-bin
	media-libs/libsdl2
	sys-libs/zlib
	media-libs/libglvnd
"

DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	local instdir="/opt/godot-mono-${PV}"
	insinto "${instdir}"
	doins -r Godot_v${PV}-stable_mono_linux_x86_64/*

	fperms +x "${instdir}/Godot_v${PV}-stable_mono_linux.x86_64"

	exeinto /usr/bin
	newexe - godot-mono <<-EOF
		#!/bin/sh
		exec ${instdir}/Godot_v${PV}-stable_mono_linux.x86_64 "\$@"
	EOF
	make_desktop_entry godot-mono "Godot Engine (Mono)" godot-mono "Development;IDE;"
}
