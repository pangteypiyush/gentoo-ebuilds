# Copyright 2024 Piyush Pangtey
# Distributed under the terms of the GNU General Public License v3

EAPI=8

inherit bash-completion-r1

DESCRIPTION="The OpenShift Command Line, part of OKD"
HOMEPAGE="
	https://www.redhat.com/en/technologies/cloud-computing/openshift
	https://github.com/openshift/oc
"
SRC_URI="
	https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${PV}/openshift-client-linux-${PV}.tar.gz -> ${P}.tar.gz
	ppc64? (
		https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${PV}/openshift-client-linux-ppc64le-${PV}.tar.gz \
		-> ${P}.tar.gz
	)
	arm64? (
		https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${PV}/openshift-client-linux-arm64-${PV}.tar.gz \
		-> ${P}.tar.gz
	)
"
S="$WORKDIR"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 x86"

src_install() {
	dobin oc

	mkdir completions
	./oc completion bash > completions/oc
	dobashcomp completions/oc
}
