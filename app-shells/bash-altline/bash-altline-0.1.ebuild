# Copyright 2024 Piyush Pangtey
# Distributed under the terms of the GNU General Public License v3

EAPI=8

PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit git-r3 python-single-r1

DESCRIPTION="Dirty powerline alternative"
HOMEPAGE=https://github.com/pangteypiyush/altline

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="+minimal"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	minimal
"

RDEPEND="
	${PYTHON_DEPS}
	app-shells/bash
"

BDEPEND="
	dev-lang/python
"

pkg_setup() {
	EGIT_REPO_URI=https://github.com/pangteypiyush/altline
	EGIT_BRANCH=master
	if use minimal; then
		EGIT_BRANCH=minimal
	fi
	python_setup
}

src_compile() {
	mkdir themes
	for theme in ./themes_src/*.ini; do
		"${EPYTHON}" ./mktheme "$theme" ./themes/$(basename ${theme%.ini})
	done
}

src_install() {
	insinto /usr/share/$PN
	doins -r themes altline

	insinto /usr/share/licenses/$PN
	doins LICENSE
}
