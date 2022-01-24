include(${CURRENT_INSTALLED_DIR}/share/qt5/qt_port_functions.cmake)

qt_submodule_installation(PATCHES
    icudt-debug-suffix.patch # https://bugreports.qt.io/browse/QTBUG-87677
    disable-tools.patch
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

if(EXISTS "${CURRENT_INSTALLED_DIR}/plugins/platforms/qminimal${VCPKG_TARGET_SHARED_LIBRARY_SUFFIX}")
    file(INSTALL "${CURRENT_INSTALLED_DIR}/plugins/platforms/qminimal${VCPKG_TARGET_SHARED_LIBRARY_SUFFIX}" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/plugins/platforms")
endif()

set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
