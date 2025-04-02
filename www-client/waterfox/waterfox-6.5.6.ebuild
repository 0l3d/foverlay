# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop optfeature

DESCRIPTION="Get privacy out of the box with Waterfox."
HOMEPAGE="https://www.waterfox.net/"
SRC_URI="https://cdn1.waterfox.net/waterfox/releases/${PV}/Linux_x86_64/${P}.tar.bz2"
S="${WORKDIR}/${PN}"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 ~amd64"

IUSE="+gtk +libXt startup-notification +mime-types +dbus-glib ffmpeg"

RDEPEND="
	gtk? ( gui-libs/gtk )
 	libXt? ( x11-libs/libXt )
 	startup-notification? ( x11-libs/startup-notification )
 	mime-types? ( app-misc/mime-types )
 	dbus-glib? ( dev-libs/dbus-glib )
	ffmpeg? ( media-video/ffmpeg )
"
DEPEND="${RDEPEND}"
BDEPEND=""

src_install() {
	dodir opt/ || die
	dodir opt/"${PN}" || die
	cp -r "${S}"/* "${ED}"/opt/"${PN}"/ || die
	dosym /opt/waterfox/waterfox-bin /usr/bin/waterfox || die
	make_desktop_entry "waterfox" "Waterfox" "/opt/${PN}/browser/chrome/icons/default/default48.png" "Network"
}

pkg_postinst () {
	optfeature_header "Optional programs for extra features:"
	optfeature "Location detection via available WiFi networks"  net-misc/networkmanager
	optfeature "Notification integration" x11-libs/libnotify
	optfeature "Audio support" media-sound/pulseaudio
	optfeature "Audio support" media-libs/alsa-lib
	optfeature "Text-to-Speech" app-accessibility/speech-dispatcher
	optfeature "Spell checking for spec lang." app-text/hunspell
}

