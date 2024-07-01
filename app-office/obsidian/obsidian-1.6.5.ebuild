# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_VERSION="102"
CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk ur vi zh-CN zh-TW
"
inherit chromium-2 desktop linux-info unpacker xdg

DESCRIPTION="A second brain, for you, forever."
HOMEPAGE="https://obsidian.md/"

SRC_URI="
	amd64? ( https://github.com/obsidianmd/obsidian-releases/releases/download/v${PV}/${P}.tar.gz -> ${P}-amd64.tar.gz )
"

DIR="/opt/${PN^}"
S="${WORKDIR}"

LICENSE="Obsidian-EULA"
SLOT="0"
KEYWORDS="amd64"
IUSE="appindicator wayland"
RESTRICT="mirror strip bindist"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-crypt/libsecret[crypt]
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
	appindicator? ( dev-libs/libayatana-appindicator )
"

QA_PREBUILT="*"

CONFIG_CHECK="~USER_NS"

set_obsidian_src_dir() {
	if use amd64; then
		S_OBSIDIAN="${WORKDIR}/${P}"
	else
		die "Obsidian only supports amd64"
	fi
}

src_configure() {
	default
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	# cleanup languages
	set_obsidian_src_dir
	cd "${S_OBSIDIAN}/locales/" || die "location change for language cleanup failed"
	chromium_remove_language_paks
}

src_install() {
	insinto "${DIR}"
	exeinto "${DIR}"

	set_obsidian_src_dir
	pushd "${S_OBSIDIAN}" >/dev/null || die "location change for main install failed"

	doexe obsidian chrome-sandbox libEGL.so libffmpeg.so libGLESv2.so libvk_swiftshader.so libvulkan.so.1
	doins chrome_100_percent.pak chrome_200_percent.pak icudtl.dat resources.pak snapshot_blob.bin \
		v8_context_snapshot.bin vk_swiftshader_icd.json
	insopts -m0755
	doins -r locales resources

	# Chrome-sandbox requires the setuid bit to be specifically set.
	# see https://github.com/electron/electron/issues/17972
	fowners root "${DIR}/chrome-sandbox"
	fperms 4711 "${DIR}/chrome-sandbox"

	[[ -x chrome_crashpad_handler ]] && doins chrome_crashpad_handler

	popd >/dev/null || die "location reset for main install failed"

	dosym "${DIR}/obsidian" "/usr/bin/obsidian"

	if use appindicator; then
		dosym ../../usr/lib64/libayatana-appindicator3.so "${DIR}/libappindicator3.so"
	fi

	if use wayland; then
		newmenu "${FILESDIR}/obsidian-wayland.desktop" obsidian.desktop
	else
		domenu "${FILESDIR}/obsidian.desktop"
	fi

	for size in 16 32 48 64 128 256 512; do
		doicon --size ${size} "${FILESDIR}/icons/${size}x${size}/apps/${PN}.png"
	done
}

pkg_postinst() {
	xdg_pkg_postinst

	ewarn "Some users have reported that running Obsidian with native Wayland"
	ewarn "support causes the software to crash. Others have it working"
	ewarn "without issue. See https://bugs.gentoo.org/915899"
	ewarn ""
	ewarn "This package now provides application entries for both Obsidian and"
	ewarn "Obsidian Wayland. If Obsidian Wayland breaks for you under Wayland,"
	ewarn "try the other Obsidian entry to launch with XWayland"
}
