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

set(LIBPSL_VERSION "0.21.2")
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/rockdaboot/libpsl/releases/download/${LIBPSL_VERSION}/libpsl-${LIBPSL_VERSION}.tar.gz"
    FILENAME "libpsl-${LIBPSL_VERSION}.tar.gz"
    SHA512 f1df72220bf4391d4701007100b0df66c833a2cbcb7481c9d13f0b9e0cad3b66d2d15d4b976e5bad60d2ad1540355112fa1acb07aa925c241d2d7cd20681c71d
)
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    REF "${LIBPSL_VERSION}"
    PATCHES
        fix-windows-build.patch
)

vcpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Druntime=${LIBPSL_RUNTIME}
        -Dbuiltin=true
        -Ddocs=false
)
vcpkg_install_meson()
vcpkg_fixup_pkgconfig()

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
file(RENAME "${CURRENT_PACKAGES_DIR}/bin/psl-make-dafsa" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/psl-make-dafsa")
file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/bin/psl-make-dafsa")
vcpkg_copy_tools(TOOL_NAMES psl AUTO_CLEAN)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
