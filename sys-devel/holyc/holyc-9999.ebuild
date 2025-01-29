# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="An implementation of Terry A. Davis's HolyC"
HOMEPAGE="https://holyc-lang.com/"
SRC_URI="https://raw.githubusercontent.com/0l3d/foverlay/refs/heads/master/sys-devel/holyc/holyc-lang_fix_math_linking.patch"
EGIT_REPO_URI="https://github.com/Jamesbarford/holyc-lang.git"
S="${WORKDIR}/${P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~amd64"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND="dev-vcs/git"

src_prepare() {
	eapply "${DISTDIR}/holyc-lang_fix_math_linking.patch"
	eapply_user
}

src_compile() {
	cd "${S}"
	if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]]; then
		emake CC="gcc" \
		CPPFLAGS="${CPPFLAGS}" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
	fi
}

src_install() {
  cd "${S}"
  emake DESTDIR="${D}" install
}

pkg_postinst() {
	elog "U0 Main()"
	elog "{"
	elog "code_here;"
	elog "}"
	elog "Main;"
	elog "Full documentation for the language and this compiler can be found here: https://holyc-lang.com/"
}
