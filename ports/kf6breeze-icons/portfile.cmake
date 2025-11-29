vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/breeze-icons
    REF v6.20.0
    SHA512 404f142762ca3be3aa5c837e840a3e545408774f4d837c83df65648782d919f6a263267d94dd12fe873c485daca8a4645d4bd0eff840c82adbb9a7c199ec5545
    HEAD_REF master
    PATCHES windows.patch
)

# Prevent KDEClangFormat from writing to source effectively blocking parallel configure
file(WRITE "${SOURCE_PATH}/.clang-format" "DisableFormat: true\nSortIncludes: false\n")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DWITH_ICON_GENERATION=OFF
        -DBUILD_TESTING=OFF
        -DKDE_INSTALL_DATAROOTDIR=share
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME KF6BreezeIcons CONFIG_PATH lib/cmake/KF6BreezeIcons)
vcpkg_copy_pdbs()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING-ICONS" "${SOURCE_PATH}/COPYING.LIB")
