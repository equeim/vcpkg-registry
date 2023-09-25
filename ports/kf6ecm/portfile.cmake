vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/extra-cmake-modules
    REF 1829894a1ea4a30ac4d1a9ead55ccf3059486474
    SHA512 a6c69206814d6f3b217a2b4b6c5bb2bf8ebe8ad2e079d1a8e7dc3d609b01e9475c466b8d8e9afb769c3e109a9737c094c0cbc31c5ce12501437c5ce5d5120d9c
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
