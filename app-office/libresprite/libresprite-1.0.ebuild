# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="LibreSprite is a free and open source program for creating and animating your sprites."
HOMEPAGE="https://github.com/LibreSprite/LibreSprite"
EGIT_REPO_URI="https://github.com/LibreSprite/LibreSprite.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

# Define some USE flags
IUSE="debug test"

# Require debug support when tests are enabled
REQUIRED_USE="test? ( debug )"

# Disable test phase when test USE flag is disabled
RESTRICT="!test? ( test )"



DEPEND="dev-build/cmake
	dev-build/ninja
	dev-cpp/gtest
	dev-vcs/git
	x11-libs/pixman
"

RDEPEND="
    x11-libs/pixman
    net-misc/curl
    dev-lang/lua
    media-libs/sdl2-image
    media-libs/giflib
    sys-libs/zlib
    media-libs/libpng
    media-libs/libjpeg-turbo
    dev-libs/tinyxml2
    media-libs/freetype
    media-libs/libwebp
"
BDEPEND=""


src_configure() {
    mkdir "${S}/build"
    cd "${S}/build"
}

src_compile() {
		cd "${S}/build"
		cmake -G Ninja .. || die
		ninja libresprite
	emake
}

src_install() {
		cd "${S}/build"
	emake "install"
		ninja install
}
