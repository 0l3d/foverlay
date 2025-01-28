# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Get privacy out of the box with Waterfox."
HOMEPAGE="https://www.waterfox.net/"
SRC_URI="https://cdn1.waterfox.net/waterfox/releases/${PV}/Linux_x86_64/${P}.tar.bz2"
S="${WORKDIR}/${PN}"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 ~amd64"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND=""

src_install() {
	dodir opt/ || die
	dodir opt/"${PN}" || die
	cp -r "${S}"/* "${ED}"/opt/"${PN}"/ || die
	dosym /opt/waterfox/waterfox-bin /usr/bin/waterfox
	make_desktop_entry "waterfox" "Waterfox" "" "Network"
}

