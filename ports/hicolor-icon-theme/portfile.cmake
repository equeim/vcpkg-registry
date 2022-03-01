set(version 0.17)

vcpkg_download_distfile(
	ARCHIVE
	URLS "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-${version}.tar.xz"
	FILENAME "hicolor-icon-theme-${version}.tar.xz"
	SHA512 eca8655930aa7e234f42630041c0053fde067b970fad1f81c55fcd4c5046c03edfdf2ede72a3e78fba2908e7da53e9463d3c5ae12ab9f5ef261e29a49f9c7a8d
)

vcpkg_extract_source_archive(
	SOURCE_PATH
	ARCHIVE "${ARCHIVE}"
)

vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
	NO_ADDITIONAL_PATHS
)

vcpkg_install_make()

# Remove debug files
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

# Allow empty include directory
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
