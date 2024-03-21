# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 desktop ninja-utils cmake

DESCRIPTION="LibreSprite is a free and open source program for creating and animating your sprites."
HOMEPAGE="https://github.com/LibreSprite/LibreSprite"
EGIT_REPO_URI="https://github.com/LibreSprite/LibreSprite.git"
# SRC_URI="https://github.com/LibreSprite/LibreSprite/archive/refs/tags/v1.0.tar.gz"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"


IUSE="+pixman +sdl2image +giflib +freetype +zlib +webp +png +tinyxml +jpeg +curl"

DEPEND="dev-build/cmake
	dev-build/ninja
	dev-cpp/gtest
	dev-vcs/git
"

RDEPEND="
    x11-libs/pixman[pixman(+)]
    net-misc/curl[curl(+)]
    dev-lang/lua
    media-libs/sdl2-image[sdl2image(+)]
    media-libs/giflib[giflib(+)]
    sys-libs/zlib[zlib(+)]
    media-libs/libpng[png(+)]
    media-libs/libjpeg-turbo[jpeg(+)]
    dev-libs/tinyxml2[tinyxml(+)]
    media-libs/freetype[freetype(+)]
    media-libs/libwebp[webp(+)]
    net-libs/nodejs
"
BDEPEND=""


src_configure() {
	mkdir "${S}/build"
	local mycmakeargs=(
        -DUSE_SHARED_PIXMAN="$(usex pixman)" 
        -DWITH_WEBP_SUPPORT="$(usex webp)" 
        -DUSE_SHARED_LIBWEBP="$(usex webp)" 
        -DUSE_SHARED_CURL="$(usex curl)" 
        -DUSE_SHARED_GIFLIB="$(usex giflib)" 
        -DUSE_SHARED_JPEGLIB="$(usex jpeg)" 
        -DUSE_SHARED_ZLIB="$(usex zlib)" 
        -DUSE_SHARED_LIBPNG="$(usex png)" 
        -DUSE_SHARED_TINYXML="$(usex tinyxml)" 
        -DUSE_SHARED_SDL2="$(usex sdl2image)" 
        -DUSE_SDL2_BACKEND="$(usex sdl2image)" 
        -DENABLE_UPDATER=OFF \
        -DUSE_SHARED_FREETYPE="$(usex freetype)" 
    )
    cmake_src_configure 
}

src_compile() {
		cd "${S}/build"
		cmake -DCMAKE_INSTALL_PREFIX=/usr -G Ninja .. || die
		eninja libresprite
}

src_install() {
		cd "${S}/build"
		DESTDIR="${D}" eninja install 
		newicon -s 48 ../data/icons/ase48.png libresprite.png
		make_desktop_entry  "libresprite %U" "LibreSprite" "/usr/share/libresprite/data/icons/ase48.png" "Office" 
}
