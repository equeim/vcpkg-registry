#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Following is copied from qtbase's portfile.cmake
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# Reminder for myself and everybody else:
# Qt cross module dependency information within the Qt respository is wrong and/or incomplete.
# Always check the toplevel CMakeLists.txt for the find_package call and search for linkage against the Qt:: targets
# Often enough certain (bigger) dependencies are only used to build examples and/or tests.
# As such getting the correct dependency information relevant for vcpkg requires a manual search/check
set(QT_IS_LATEST ON)

## All above goes into the qt_port_hashes in the future

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Path here is changed to point to qtbase's directory
include("${VCPKG_ROOT_DIR}/ports/qtbase/cmake/qt_install_submodule.cmake")
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set(QTBASE_PATCHES
        allow_outside_prefix.patch
        config_install.patch
        fix_cmake_build.patch
        harfbuzz.patch
        fix_egl.patch
        fix_egl_2.patch
        installed_dir.patch
        GLIB2-static.patch # alternative is to force pkg-config
        clang-cl_source_location.patch
        clang-cl_QGADGET_fix.diff
        )

if(VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
    list(APPEND ${QTBASE_PATCHES} env.patch)
endif()

list(APPEND ${QTBASE_PATCHES}
        dont_force_cmakecache_latest.patch
    )

set(TOOL_NAMES
    androiddeployqt
    androidtestrunner
    cmake_automoc_parser
    moc
    qdbuscpp2xml
    qdbusxml2cpp
    qlalr
    qmake
    qmake6
    qvkgen
    rcc
    tracegen
    uic
    qtpaths
    qtpaths6
    windeployqt
    windeployqt6
    macdeployqt
    macdeployqt6
    androiddeployqt6
    syncqt
    tracepointgen
)

set(VCPKG_LIBRARY_LINKAGE dynamic)
set(ANDROID_SDK_ROOT "$ENV{ANDROID_SDK_HOME}")

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Following is ours
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

file(READ "${VCPKG_ROOT_DIR}/ports/qtbase/vcpkg.json" qtbase-json)
string(JSON qtbase-version GET "${qtbase-json}" version)
string(JSON qtbase-port-version ERROR_VARIABLE qtbase-port-version-error GET "${qtbase-json}" port-version)
if(NOT qtbase-port-version-error STREQUAL "NOTFOUND")
    set(qtbase-port-version "0")
endif()
set(qtbase-full-version "${qtbase-version}#${qtbase-port-version}")
message("qtbase version is ${qtbase-full-version}")

set(qtbase-compatible-version "6.5.0#2")

if(NOT qtbase-full-version STREQUAL qtbase-compatible-version)
    message(FATAL_ERROR "qtbase version must be ${qtbase-compatible-version}")
endif()

list(TRANSFORM QTBASE_PATCHES PREPEND "${VCPKG_ROOT_DIR}/ports/qtbase/")

set(BACKUP_PORT ${PORT})
set(PORT qtbase)
qt_install_submodule(
    PATCHES
        ${QTBASE_PATCHES}
        # tremotesf-android patches
        qopensslbackend-static.patch
    TOOL_NAMES ${TOOL_NAMES}
    CONFIGURE_OPTIONS
        # From qtbase's portfile.cmake
        -DFEATURE_force_debug_info=ON
        -DFEATURE_relocatable=ON

        # tremotesf-android options
        --log-level=STATUS
        -DINPUT_openssl=linked
        -DFEATURE_androiddeployqt=OFF
        -DFEATURE_animation=OFF
        -DFEATURE_backtrace=OFF
        -DFEATURE_brotli=ON
        -DFEATURE_cborstreamwriter=OFF
        -DFEATURE_commandlineparser=OFF
        -DFEATURE_concatenatetablesproxymodel=OFF
        -DFEATURE_datetimeparser=OFF
        -DFEATURE_dbus=OFF
        -DFEATURE_dnslookup=OFF
        -DFEATURE_dtls=OFF
        -DFEATURE_easingcurve=OFF
        -DFEATURE_filesystemiterator=OFF
        -DFEATURE_filesystemwatcher=OFF
        -DFEATURE_gestures=OFF
        -DFEATURE_glib=OFF
        -DFEATURE_gssapi=OFF
        -DFEATURE_gui=OFF
        -DFEATURE_hijricalendar=OFF
        -DFEATURE_icu=OFF
        -DFEATURE_identityproxymodel=OFF
        -DFEATURE_inotify=OFF
        -DFEATURE_islamiccivilcalendar=OFF
        -DFEATURE_itemmodel=OFF
        -DFEATURE_jalalicalendar=OFF
        -DFEATURE_journald=OFF
        -DFEATURE_libproxy=OFF
        -DFEATURE_library=OFF
        -DFEATURE_localserver=OFF
        -DFEATURE_mimetype=OFF
        -DFEATURE_mimetype_database=OFF
        -DFEATURE_networkdiskcache=OFF
        -DFEATURE_networklistmanager=OFF
        -DFEATURE_process=OFF
        -DFEATURE_processenvironment=OFF
        -DFEATURE_proxymodel=OFF
        -DFEATURE_publicsuffix_qt=ON
        -DFEATURE_publicsuffix_system=OFF
        -DFEATURE_qmake=OFF
        -DFEATURE_sctp=OFF
        -DFEATURE_settings=OFF
        -DFEATURE_sharedmemory=OFF
        -DFEATURE_shortcut=OFF
        -DFEATURE_slog2=OFF
        -DFEATURE_sortfilterproxymodel=OFF
        -DFEATURE_sql=OFF
        -DFEATURE_sspi=OFF
        -DFEATURE_stringlistmodel=OFF
        -DFEATURE_syslog=OFF
        -DFEATURE_system_pcre2=ON
        -DFEATURE_system_proxies=OFF
        -DFEATURE_system_zlib=ON
        -DFEATURE_systemsemaphore=OFF
        -DFEATURE_temporaryfile=OFF
        -DFEATURE_testlib=OFF
        -DFEATURE_timezone=OFF
        -DFEATURE_topleveldomain=ON
        -DFEATURE_translation=OFF
        -DFEATURE_transposeproxymodel=OFF
        -DFEATURE_udpsocket=OFF
        -DFEATURE_xml=OFF
        -DFEATURE_xmlstream=OFF
        -DFEATURE_zstd=OFF
    CONFIGURE_OPTIONS_DEBUG
        # From qtbase's portfile.cmake
        -DFEATURE_debug=ON
)
set(PORT ${BACKUP_PORT})
file(RENAME "${CURRENT_PACKAGES_DIR}/share/qtbase" "${CURRENT_PACKAGES_DIR}/share/${PORT}")

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Following is copied from qtbase's portfile.cmake
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

file(CONFIGURE OUTPUT "${CURRENT_PACKAGES_DIR}/share/${PORT}/port_status.cmake" CONTENT "set(qtbase_with_icu OFF)\n")

set(other_files qt-cmake
                 qt-cmake-private
                 qt-cmake-standalone-test
                 qt-configure-module
                 qt-internal-configure-tests
                 )
if(CMAKE_HOST_WIN32)
    set(script_suffix .bat)
else()
    set(script_suffix)
endif()
list(TRANSFORM other_files APPEND "${script_suffix}")

list(APPEND other_files 
                android_cmakelist_patcher.sh
                android_emulator_launcher.sh
                ensure_pro_file.cmake
                syncqt.pl
                target_qt.conf
                qt-cmake-private-install.cmake
                qt-testrunner.py
                sanitizer-testrunner.py
                )

foreach(_config debug release)
    if(_config MATCHES "debug")
        set(path_suffix debug/)
    else()
        set(path_suffix)
    endif()
    if(NOT EXISTS "${CURRENT_PACKAGES_DIR}/${path_suffix}bin")
        continue()
    endif()
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/Qt6/bin/${path_suffix}")
    foreach(other_file IN LISTS other_files)
        if(EXISTS "${CURRENT_PACKAGES_DIR}/${path_suffix}bin/${other_file}")
            set(target_file "${CURRENT_PACKAGES_DIR}/tools/Qt6/bin/${path_suffix}${other_file}")
            file(RENAME "${CURRENT_PACKAGES_DIR}/${path_suffix}bin/${other_file}" "${target_file}")
            file(READ "${target_file}" _contents)
            if(_config MATCHES "debug")
                string(REPLACE "..\\share\\" "..\\..\\..\\..\\share\\" _contents "${_contents}")
                string(REPLACE "../share/" "../../../../share/" _contents "${_contents}")
            else()
                string(REPLACE "..\\share\\" "..\\..\\..\\share\\" _contents "${_contents}")
                string(REPLACE "../share/" "../../../share/" _contents "${_contents}")
            endif()
            string(REGEX REPLACE "set cmake_path=[^\n]+\n" "set cmake_path=cmake\n" _contents "${_contents}")
            file(WRITE "${target_file}" "${_contents}")
        endif()
    endforeach()
endforeach()

# Fixup qt.toolchain.cmake
set(qttoolchain "${CURRENT_PACKAGES_DIR}/share/Qt6/qt.toolchain.cmake")
file(READ "${qttoolchain}" toolchain_contents)
string(REGEX REPLACE "set\\\(__qt_initially_configured_toolchain_file [^\\\n]+\\\n" "" toolchain_contents "${toolchain_contents}")
string(REGEX REPLACE "set\\\(__qt_chainload_toolchain_file [^\\\n]+\\\n" "set(__qt_chainload_toolchain_file \"\${VCPKG_CHAINLOAD_TOOLCHAIN_FILE}\")" toolchain_contents "${toolchain_contents}")
string(REGEX REPLACE "set\\\(VCPKG_CHAINLOAD_TOOLCHAIN_FILE [^\\\n]+\\\n" "" toolchain_contents "${toolchain_contents}")
string(REGEX REPLACE "set\\\(__qt_initial_c_compiler [^\\\n]+\\\n" "" toolchain_contents "${toolchain_contents}")
string(REGEX REPLACE "set\\\(__qt_initial_cxx_compiler [^\\\n]+\\\n" "" toolchain_contents "${toolchain_contents}")
string(REPLACE "${CURRENT_HOST_INSTALLED_DIR}" "\${vcpkg_installed_dir}/${HOST_TRIPLET}" toolchain_contents "${toolchain_contents}")
file(WRITE "${qttoolchain}" "${toolchain_contents}")

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static" OR NOT VCPKG_TARGET_IS_WINDOWS)
    if(VCPKG_CROSSCOMPILING)
        file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin/qmake" "${CURRENT_PACKAGES_DIR}/debug/bin/qmake") # qmake has been moved so this is the qmake helper script
    endif()
    file(GLOB_RECURSE _bin_files "${CURRENT_PACKAGES_DIR}/bin/*")
    if(NOT _bin_files) # Only clean if empty otherwise let vcpkg throw and error.
        file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin/" "${CURRENT_PACKAGES_DIR}/debug/bin/")
    else()
        message(STATUS "Files in '/bin':${_bin_files}")
    endif()
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/Qt6/QtBuildInternals")

if(NOT VCPKG_TARGET_IS_OSX)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/Qt6/macos")
endif()
if(NOT VCPKG_TARGET_IS_IOS)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/Qt6/ios")
endif()

file(RELATIVE_PATH installed_to_host "${CURRENT_INSTALLED_DIR}" "${CURRENT_HOST_INSTALLED_DIR}")
file(RELATIVE_PATH host_to_installed "${CURRENT_HOST_INSTALLED_DIR}" "${CURRENT_INSTALLED_DIR}")
if(installed_to_host)
    string(APPEND installed_to_host "/")
    string(APPEND host_to_installed "/")
endif()

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Path here is changed to point to qtbase's directory
set(_file "${VCPKG_ROOT_DIR}/ports/qtbase/qt.conf.in")
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set(REL_PATH "")
set(REL_HOST_TO_DATA "\${CURRENT_INSTALLED_DIR}/")
configure_file("${_file}" "${CURRENT_PACKAGES_DIR}/tools/Qt6/qt_release.conf" @ONLY) # For vcpkg-qmake
set(BACKUP_CURRENT_INSTALLED_DIR "${CURRENT_INSTALLED_DIR}")
set(BACKUP_CURRENT_HOST_INSTALLED_DIR "${CURRENT_HOST_INSTALLED_DIR}")
set(CURRENT_INSTALLED_DIR "./../../../")
set(CURRENT_HOST_INSTALLED_DIR "${CURRENT_INSTALLED_DIR}${installed_to_host}")

## Configure installed qt.conf
set(REL_HOST_TO_DATA "${host_to_installed}")
configure_file("${_file}" "${CURRENT_PACKAGES_DIR}/tools/Qt6/bin/qt.conf")
set(REL_PATH debug/)
configure_file("${_file}" "${CURRENT_PACKAGES_DIR}/tools/Qt6/bin/qt.debug.conf")

set(CURRENT_INSTALLED_DIR "${BACKUP_CURRENT_INSTALLED_DIR}")
set(CURRENT_HOST_INSTALLED_DIR "${BACKUP_CURRENT_HOST_INSTALLED_DIR}")
set(REL_HOST_TO_DATA "\${CURRENT_INSTALLED_DIR}/")
configure_file("${_file}" "${CURRENT_PACKAGES_DIR}/tools/Qt6/qt_debug.conf" @ONLY) # For vcpkg-qmake

if(VCPKG_TARGET_IS_WINDOWS)
    set(_DLL_FILES brotlicommon brotlidec bz2 freetype harfbuzz libpng16)
    set(DLLS_TO_COPY "")
    foreach(_file IN LISTS _DLL_FILES)
        if(EXISTS "${CURRENT_INSTALLED_DIR}/bin/${_file}.dll")
            list(APPEND DLLS_TO_COPY "${CURRENT_INSTALLED_DIR}/bin/${_file}.dll")
        endif()
    endforeach()
    file(COPY ${DLLS_TO_COPY} DESTINATION "${CURRENT_PACKAGES_DIR}/tools/Qt6/bin")
endif()

set(hostinfofile "${CURRENT_PACKAGES_DIR}/share/Qt6HostInfo/Qt6HostInfoConfig.cmake")
file(READ "${hostinfofile}" _contents)
string(REPLACE [[set(QT6_HOST_INFO_LIBEXECDIR "bin")]] [[set(QT6_HOST_INFO_LIBEXECDIR "tools/Qt6/bin")]] _contents "${_contents}")
string(REPLACE [[set(QT6_HOST_INFO_BINDIR "bin")]] [[set(QT6_HOST_INFO_BINDIR "tools/Qt6/bin")]] _contents "${_contents}")
file(WRITE "${hostinfofile}" "${_contents}")

if(NOT VCPKG_CROSSCOMPILING OR EXISTS "${CURRENT_PACKAGES_DIR}/share/Qt6CoreTools/Qt6CoreToolsAdditionalTargetInfo.cmake")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/Qt6CoreTools/Qt6CoreToolsAdditionalTargetInfo.cmake"
                         "PACKAGE_PREFIX_DIR}/bin/syncqt"
                         "PACKAGE_PREFIX_DIR}/tools/Qt6/bin/syncqt")
endif()

set(configfile "${CURRENT_PACKAGES_DIR}/share/Qt6CoreTools/Qt6CoreToolsTargets-debug.cmake")
if(EXISTS "${configfile}")
    file(READ "${configfile}" _contents)
    if(EXISTS "${CURRENT_PACKAGES_DIR}/tools/Qt6/bin/qmake.exe")
        file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/qmake.debug.bat" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/Qt6/bin")
        string(REPLACE [[ "${_IMPORT_PREFIX}/tools/Qt6/bin/qmake.exe"]] [[ "${_IMPORT_PREFIX}/tools/Qt6/bin/qmake.debug.bat"]] _contents "${_contents}")
    endif()
    if(EXISTS "${CURRENT_PACKAGES_DIR}/tools/Qt6/bin/qtpaths.exe")
        file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/qtpaths.debug.bat" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/Qt6/bin")
        string(REPLACE [[ "${_IMPORT_PREFIX}/tools/Qt6/bin/qtpaths.exe"]] [[ "${_IMPORT_PREFIX}/tools/Qt6/bin/qtpaths.debug.bat"]] _contents "${_contents}")
    endif()
    if(EXISTS "${CURRENT_PACKAGES_DIR}/tools/Qt6/bin/windeployqt.exe")
        file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/windeployqt.debug.bat" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/Qt6/bin")
        string(REPLACE [[ "${_IMPORT_PREFIX}/tools/Qt6/bin/windeployqt.exe"]] [[ "${_IMPORT_PREFIX}/tools/Qt6/bin/windeployqt.debug.bat"]] _contents "${_contents}")
    endif()
    file(WRITE "${configfile}" "${_contents}")
endif()

if(VCPKG_CROSSCOMPILING)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/Qt6/Qt6Dependencies.cmake" "${CURRENT_HOST_INSTALLED_DIR}" "\${CMAKE_CURRENT_LIST_DIR}/../../../${HOST_TRIPLET}")
endif()
