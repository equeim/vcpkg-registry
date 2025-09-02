vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/extra-cmake-modules
    REF v6.17.0
    SHA512 8305e02b0e2be2777149479d79dd45b1cdb6dbb1a5d0a6a1ba8c8f12e015928ef387737243d707a405eead67893974a7dede78fde13e04850e993db854d0c1dd
    HEAD_REF master
    PATCHES d65b2d73c833e8200eca10c74fa20bce3cb7e33b.patch fix-relative-paths.patch
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_HTML_DOCS=OFF
        -DBUILD_MAN_DOCS=OFF
        -DBUILD_QTHELP_DOCS=OFF
        -DBUILD_TESTING=OFF
)

vcpkg_cmake_install()

# Remove debug files
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING-CMAKE-SCRIPTS" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

# Allow empty include directory
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
