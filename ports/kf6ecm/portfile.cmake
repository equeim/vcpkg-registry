vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/extra-cmake-modules
    REF 3b883e70f54016374de00d1ba1533290011582a0
    SHA512 c2410d19540ace7805b94ba71b572d1ce1a426a3ec7c11f8315445c9292b56203210f099860af973bc5d06f0c74b7fe3ad6ea9a1584e4371ca6e33be732fe78a
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
