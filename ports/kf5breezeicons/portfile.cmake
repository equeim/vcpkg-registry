set(version 5.89.0)
set(version_without_patch 5.89)

if (VCPKG_TARGET_IS_WINDOWS)
	set(archive_extension zip)
	set(archive_sha512 9cc255cb960133b8fc025def0135f1ea6a7de8d39a3fd9314fa0db7e144ac5443e94e1726b3d859c338e5b263ffea57e48c85674bc68ef61799966e977556283)
else()
	set(archive_extension tar.xz)
	set(archive_sha512 8aeade18fde4c45df10a396987473220741c4dad736f2077f7075ebdc4ca4ed3cdb8975c5a9604a2f56b81b7cb4bf53117e33f7faff4e5b3b6293fefe8cccc70)
endif()

vcpkg_download_distfile(
	ARCHIVE
	URLS "https://download.kde.org/stable/frameworks/${version_without_patch}/breeze-icons-${version}.${archive_extension}"
	FILENAME "breeze-icons-${version}.${archive_extension}"
	SHA512 "${archive_sha512}"
)

vcpkg_extract_source_archive(
	SOURCE_PATH
	ARCHIVE "${ARCHIVE}"
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBINARY_ICONS_RESOURCE=OFF
        -DWITH_ICON_GENERATION=OFF
        -DBUILD_TESTING=OFF
        -DKDE_INSTALL_DATAROOTDIR="share"
)

vcpkg_cmake_install()

# Remove debug files
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

file(INSTALL "${SOURCE_PATH}/COPYING-ICONS" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

# Allow empty include directory
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
