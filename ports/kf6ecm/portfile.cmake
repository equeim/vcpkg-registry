vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/extra-cmake-modules
    REF 41f2e5863b01d86088adf5e2e49ad0871e02117f
    SHA512 25f4bd6c7a564af44b0bb6b068091bb4faa9ffbaa3f9769f01f64e5190d5c2070bf2fd3e87e4e30a142242c29b30a9ba941dee9dcc3e1f93553f9c828decc961
    HEAD_REF master
    PATCHES 0789062084912b14f1b3dc4c3103e8b5d1f819e3.diff
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

