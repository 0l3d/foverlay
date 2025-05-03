# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="The world’s fastest framework for building websites."
HOMEPAGE="https://gohugo.io"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=" extended"
REQUIRED_USE="extended? ( || ( amd64  ) ) "
DEPEND=""
RDEPEND="extended? ( sys-devel/gcc sys-libs/glibc  ) "
S="${WORKDIR}"


SRC_URI="
  amd64? ( !extended? (  https://github.com/gohugoio/hugo/releases/download/v0.147.1/hugo_${PV}_linux-amd64.tar.gz -> ${P}-hugo_${PV}_linux-amd64.tar.gz  )  )  
  amd64? ( extended? (  https://github.com/gohugoio/hugo/releases/download/v0.147.1/hugo_extended_${PV}_Linux-64bit.tar.gz -> ${P}-hugo_extended_${PV}_Linux-64bit.tar.gz  )  )  
"

src_unpack() {
  if use amd64 && ! use extended ; then
    unpack "${DISTDIR}/${P}-hugo_${PV}_linux-amd64.tar.gz" || die "Can't unpack archive file"
  fi
  if use amd64 && use extended; then
    unpack "${DISTDIR}/${P}-hugo_extended_${PV}_Linux-64bit.tar.gz" || die "Can't unpack archive file"
  fi
}

src_install() {
  exeinto /opt/bin
  if use amd64 && ! use extended ; then
    newexe "hugo" "hugo" || die "Failed to install Binary"
  fi
  if use amd64 && use extended; then
    newexe "hugo" "hugo" || die "Failed to install Binary"
  fi
}
