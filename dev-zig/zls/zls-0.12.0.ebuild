# Copyright 2024 Piyush Pangtey
# Distributed under the terms of the GNU General Public License v3

EAPI=8

DESCRIPTION="Zig language server"
HOMEPAGE="https://github.com/zigtools/zls"
SRC_URI="
	https://github.com/zigtools/zls/releases/download/${PV}/zls-x86_64-linux.tar.xz -> ${P}.tar.xz
	x86? ( https://github.com/zigtools/zls/releases/download/${PV}/zls-x86-linux.tar.xz -> ${P}.tar.xz )
	arm64? ( https://github.com/zigtools/zls/releases/download/${PV}/zls-aarch64-linux.tar.xz -> ${P}.tar.xz )
"

S="${WORKDIR}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

src_install() {
	dobin zls
	dodoc README.md

	insinto /usr/share/licenses/$PN
	doins LICENSE
}
