# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson ninja-utils

DESCRIPTION="Vala Panel Application Menu is a Global Menu applet for use with Vala Panel, xfce4-panel and mate-panel (Budgie 10.x is also planned). unity-gtk-module is used as a backend, and thus must also be installed (see instructions, below)."
HOMEPAGE="https://github.com/vala-panel-project/vala-panel-appmenu"
EGIT_REPO_URI="https://gitlab.com/vala-panel-project/vala-panel-appmenu.git"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+xfce -mate -budgie -valapanel -auto_features -jayatana +appmenu-gtk-module"

DEPEND="
	>=dev-libs/glib-2.50.0
	>=x11-libs/gtk+-3.22.0
	>=dev-lang/vala-0.24.0
	>=x11-libs/libwnck-3.4.8
	valapanel? ( x11-misc/vala-panel )
	xfce? ( xfce-base/xfce4-panel )
	mate? ( mate-base/mate-panel ) 
"
RDEPEND="${DEPEND}"

src_configure() {
	eselect vala set 1
	mkdir ${S}/build
	cd ${S}/build
		local emesonargs=(
                $(meson_feature xfce)
				$(meson_feature mate)
				$(meson_feature budgie)
				$(meson_feature jayatana)
				$(meson_feature valapanel)
				$(meson_feature appmenu-gtk-module)
    			$(meson_feature auto_features)
		)
        meson_src_configure
}
src_compile() {
	setup_meson_src_configure
	cd ${S}/build
	meson_src_compile
}
src_install () {
	DESTDIR="${D}" meson_src_install
}
