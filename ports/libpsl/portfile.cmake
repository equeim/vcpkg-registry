vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        icu LIBPSL_RUNTIME_ICU
        libidn2 LIBPSL_RUNTIME_LIBIDN2
)

if (LIBPSL_RUNTIME_ICU AND LIBPSL_RUNTIME_LIBIDN2)
    message(FATAL_ERROR "Both icu and libidn2 features can't be enabled, they are mutually exclusive")
elseif ((NOT LIBPSL_RUNTIME_ICU) AND (NOT LIBPSL_RUNTIME_LIBIDN2))
    message(FATAL_ERROR "Either icu or libidn2 feature must be enabled")
endif()

if (LIBPSL_RUNTIME_ICU)
    set(LIBPSL_RUNTIME "libicu")
elseif (LIBPSL_RUNTIME_LIBIDN2)
    set(LIBPSL_RUNTIME "libidn2")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO rockdaboot/libpsl
    REF 477c58298f8c4f5aeff3c223e1904d978635e353
)

vcpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Druntime=${LIBPSL_RUNTIME}
        -Dbuiltin=true
        -Ddocs=false
        -Dtests=false
)
vcpkg_install_meson()
vcpkg_fixup_pkgconfig()

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
file(RENAME "${CURRENT_PACKAGES_DIR}/bin/psl-make-dafsa" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/psl-make-dafsa")
file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/bin/psl-make-dafsa")
vcpkg_copy_tools(TOOL_NAMES psl AUTO_CLEAN)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
