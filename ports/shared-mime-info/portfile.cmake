set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

vcpkg_from_gitlab(
    OUT_SOURCE_PATH SOURCE_PATH
    GITLAB_URL "https://gitlab.freedesktop.org"
    REPO "xdg/shared-mime-info"
    REF "${VERSION}"
    SHA512 "17b443c2c09a432d09e4c83db956f8c0c3a768cfa9ffb8c87cd2d7c9002b95d010094e2bc64dd35946205a0f8b2d87c4f8f0a1faec86443e2edd502aa8f7cc8f"
)

set(VCPKG_BUILD_TYPE release)  # only data

file(INSTALL "${SOURCE_PATH}/data/freedesktop.org.xml.in" DESTINATION "${CURRENT_PACKAGES_DIR}/share/mime/packages" RENAME "freedesktop.org.xml")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")

