# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson vala xdg git-r3

DESCRIPTION="Vala rewrite of SimplePanel"
HOMEPAGE="https://gitlab.com/vala-panel-project/vala-panel"
	EGIT_REPO_URI="
		https://gitlab.com/vala-panel-project/${PN}.git
		https://github.com/rilian-la-te/${PN}.git
	"

RESTRICT="mirror"
LICENSE="LGPL-3"
SLOT="0"

DEPEND="
	>=dev-libs/glib-2.56.0
	>=x11-libs/gtk+-3.22.0:3
	>=x11-libs/libwnck-3.4.7:3
	dev-libs/gobject-introspection
	x11-libs/libX11
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	vala_src_prepare
	xdg_environment_reset
	default
}

pkg_preinst() {
	gnome2_schemas_savelist
	xdg_pkg_preinst
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}
