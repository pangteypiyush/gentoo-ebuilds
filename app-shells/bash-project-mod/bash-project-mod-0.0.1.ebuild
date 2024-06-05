# Copyright 2024 Piyush Pangtey
# Distributed under the terms of the GNU General Public License v3

EAPI=8

inherit git-r3 bash-completion-r1

DESCRIPTION="Bash Project mod"
HOMEPAGE="https://github.com/pangteypiyush/bash-project-mod"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	app-shells/bash
	app-shells/bash-completion
"

EGIT_REPO_URI="https://github.com/pangteypiyush/bash-project-mod"
EGIT_BRANCH="master"

src_install() {
	insinto /usr/share/$PN
	doins project-mod

	insinto /usr/share/licenses/$PN
	doins LICENSE

	DIR=/usr/share/bash-completion/completions
	newbashcomp project-completion lsp
	bashcomp_alias lsp cdp chproject
}
