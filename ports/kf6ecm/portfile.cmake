vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/extra-cmake-modules
    REF v5.246.1
    SHA512 3c2b72ad88ed2035c95f5000673d0da21c169ba50a7959764d679ef3913cf95820159dc06f04d5c7fa5b981165b91ebb7c6ab7a8300c2c22de726cd9659cf12d
    HEAD_REF master
    PATCHES d65b2d73c833e8200eca10c74fa20bce3cb7e33b.patch
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
