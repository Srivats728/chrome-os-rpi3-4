# Copyright (c) 2022 Fyde Innovations Limited and the openFyde Authors.
# Distributed under the license specified in the root directory of this project.

# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f108dcf6394733b59e9c6b841aa2759f977bad6f"
CROS_WORKON_TREE="29dfc93a94b403c5f0744fa2c51b24c78b5f06eb"
CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="mesa-freedreno"
CROS_WORKON_EGIT_BRANCH="chromeos-freedreno"
#ECLASS_DEBUG_OUTPUT="on"

KEYWORDS="*"

inherit base meson flag-o-matic cros-workon

DESCRIPTION="The Mesa 3D Graphics Library"
HOMEPAGE="http://mesa3d.org/"

# Most of the code is MIT/X11.
# GLES[2]/gl[2]{,ext,platform}.h are SGI-B-2.0
LICENSE="MIT SGI-B-2.0"

IUSE="debug vulkan egl gles2"

COMMON_DEPEND="
	dev-libs/expat:=
	>=x11-libs/libdrm-2.4.94:=
"

RDEPEND="${COMMON_DEPEND}
"

DEPEND="${COMMON_DEPEND}
"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

src_configure() {
	emesonargs+=(
		-Dllvm=disabled
		-Ddri3=disabled
		-Dshader-cache=disabled
		-Dglx=disabled
		-Degl=enabled
		-Dgbm=disabled
		-Dgles1=enabled
		-Dgles2=enabled
		-Dshared-glapi=enabled
		-Ddri-drivers=
		-Dgallium-drivers=vc4,v3d,kmsro
		-Dgallium-vdpau=disabled
		-Dgallium-xa=disabled
		-Dplatforms=
		-Dtools=
		--buildtype $(usex debug debug release)
		-Dvulkan-drivers=$(usex vulkan broadcom '')
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	find "${ED}" -name '*kgsl*' -exec rm -f {} +
  find "${ED}"/usr/lib/dri -not -name 'v*' -exec rm -f {} +
	rm -v -rf "${ED}/usr/include"
}
