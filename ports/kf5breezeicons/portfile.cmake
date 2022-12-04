set(version 5.98.0)
set(version_without_patch 5.98)

if (VCPKG_TARGET_IS_WINDOWS)
	set(archive_extension zip)
	set(archive_sha512 8d7ecf951258ddfe77f7cc4dd798eabfcaeee40bcfb020656ad7fb036c999a9305a5aaf33ac422609a8dc225d4da7bd54bb2b7a3621efd08405b687204c78a90)
else()
	set(archive_extension tar.xz)
	set(archive_sha512 3983baac054b576b3c8a4172ef07b4422a7ebafb9b624194ad40c11a37d111c2981df87e001b42196ae1e9ac4479c0b44e36838bbba53e19874e1a1e95e5894c)
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

# Prevent KDEClangFormat from writing to source effectively blocking parallel configure
file(WRITE "${SOURCE_PATH}/.clang-format" "DisableFormat: true\nSortIncludes: false\n")

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
