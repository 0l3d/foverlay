# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cargo

DESCRIPTION="An extremely simple lofi player."
HOMEPAGE="https://github.com/talwat/lowfi"
EGIT_REPO_URI="https://github.com/talwat/lowfi.git"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/alsa-lib
	dev-libs/openssl
	dev-lang/rust-bin
"
DEPEND="${RDEPEND}"
BDEPEND=""

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_compile() {
	cd "${S}"
	cargo_gen_config
	cargo_src_compile --frozen --all-features
}

src_install() {
	cargo_src_install
}
