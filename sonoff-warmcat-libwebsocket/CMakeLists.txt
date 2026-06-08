cmake_minimum_required(VERSION 3.19)

project("sonoff" LANGUAGES C)
include(ExternalProject)
include(FetchContent)
add_executable(${PROJECT_NAME} "main.c")

set(LIBUV_VERSION "v1.48.0")
set(LIBUV_REPO "https://github.com/libuv/libuv.git")
FetchContent_Declare(uv_a GIT_REPOSITORY ${LIBUV_REPO} GIT_TAG ${LIBUV_VERSION})
FetchContent_MakeAvailable(uv_a)

set(ZLIB_VERSION "v1.3.1")
set(ZLIB_REPO "https://github.com/madler/zlib.git")
set(ZLIB_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
FetchContent_Declare(zlib GIT_REPOSITORY ${ZLIB_REPO} GIT_TAG ${ZLIB_VERSION})
FetchContent_MakeAvailable(zlib)
set_target_properties(zlib PROPERTIES EXCLUDE_FROM_ALL TRUE)

set(LIBUV_DIR "${uv_a_SOURCE_DIR}")
set(ZLIB_DIR "${zlib_SOURCE_DIR}")
set(ZLIB_ROOT "${zlib_SOURCE_DIR}" CACHE STRING "" FORCE)
set(ZLIB_LIBRARY "${CMAKE_BINARY_DIR}/_deps/zlib-build/libz.a" CACHE FILEPATH "" FORCE)
set(ZLIB_INCLUDE_DIR "${zlib_SOURCE_DIR}" CACHE PATH "" FORCE)
set(ZLIB_FOUND TRUE CACHE BOOL "" FORCE)

set(WARMCAT_VERSION "3e8ec88f20a9bff437a86cf68a50ebae850424ed")
set(WARMCAT_DOWNLOAD "https://github.com/warmcat/libwebsockets/archive/${WARMCAT_VERSION}.tar.gz")
set(WARMCAT_BIN "${CMAKE_BINARY_DIR}/warmcat")
file(MAKE_DIRECTORY ${WARMCAT_BIN}/include)
ExternalProject_Add(libwebsockets_proj
    URL ${WARMCAT_DOWNLOAD}
    DEPENDS uv_a zlibstatic
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${WARMCAT_BIN}
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -DLWS_WITH_STATIC=ON
        -DLWS_WITH_SHARED=OFF
        -DLWS_ROLE_H1=ON
        -DLWS_ROLE_WS=ON
        -DLWS_ROLE_H2=ON
        -DLWS_ROLE_MQTT=OFF
        -DLWS_ROLE_RAW_FILE=OFF
        -DLWS_ROLE_RAW_PROXY=OFF
        -DLWS_WITH_SSL=OFF
        -DLWS_WITH_MBEDTLS=OFF
        -DLWS_WITH_GNUTLS=OFF
        -DLWS_WITH_OPENSSL=OFF
        -DLWS_WITH_WOLFSSL=OFF
        -DLWS_WITH_MINIMAL_EXAMPLES=OFF
        -DLWS_WITHOUT_TESTAPPS=ON
        -DLWS_WITHOUT_TEST_SERVER=ON
        -DLWS_WITHOUT_TEST_SERVER_EXTPOLL=ON
        -DLWS_WITHOUT_TEST_PING=ON
        -DLWS_WITHOUT_TEST_CLIENT=ON
        -DLWS_WITH_PLUGINS=OFF
        -DLWS_WITH_PLUGINS_BUILTIN=OFF
        -DLWS_WITH_CGI=OFF
        -DLWS_WITH_HTTP_PROXY=OFF
        -DLWS_WITH_HTTP_BASIC_AUTH=OFF
        -DLWS_WITH_HTTP_UNCOMMON_HEADERS=ON
        -DLWS_WITH_ZIP_FOPS=OFF
        -DLWS_WITH_JPEG=OFF
        -DLWS_WITH_PNG=OFF
        -DLWS_WITH_DLO=OFF
        -DLWS_WITH_LHP=OFF
        -DLWS_WITH_SECURE_STREAMS=OFF
        -DLWS_WITH_SECURE_STREAMS_PROXY_API=OFF
        -DLWS_WITH_SECURE_STREAMS_STATIC_POLICY_ONLY=OFF
        -DLWS_WITH_STRUCT_JSON=OFF
        -DLWS_WITH_STRUCT_SQLITE3=OFF
        -DLWS_WITH_CBOR=OFF
        -DLWS_WITH_CBOR_FLOAT=OFF
        -DLWS_WITH_DISKCACHE=OFF
        -DLWS_WITH_THREADPOOL=OFF
        -DLWS_WITH_LIBUV=ON
        -DLWS_WITH_LIBEVENT=OFF
        -DLWS_WITH_LIBEV=OFF
        -DLWS_WITH_GLIB=OFF
        -DLWS_WITH_ZLIB=ON
        -DLWS_WITH_BUNDLED_ZLIB=OFF
        -DLWS_WITHOUT_EXTENSIONS=ON
        -DZLIB_ROOT=${ZLIB_DIR}
        -DZLIB_LIBRARY=${ZLIB_LIBRARY}
        -DZLIB_INCLUDE_DIR=${ZLIB_INCLUDE_DIR}
        -DZLIB_FOUND=TRUE
        -DLIBUV_INCLUDE_DIRS=${LIBUV_DIR}/include
        -DLWS_MBEDTLS_INCLUDE_DIRS=${MBEDTLS_DIR}/include
    UPDATE_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --target install
)
add_library(libwebsockets STATIC IMPORTED)
set_target_properties(libwebsockets PROPERTIES
    IMPORTED_LOCATION ${WARMCAT_BIN}/lib/libwebsockets.a
    INTERFACE_INCLUDE_DIRECTORIES ${WARMCAT_BIN}/include
)
add_dependencies(libwebsockets libwebsockets_proj)
add_dependencies(${PROJECT_NAME} libwebsockets)
target_link_libraries(${PROJECT_NAME} PRIVATE libwebsockets uv_a zlibstatic)
