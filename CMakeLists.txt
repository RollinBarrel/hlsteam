cmake_minimum_required(VERSION 3.20)

project(hlsteam)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(steam.hdll 
    native/cloud.cpp
    native/common.cpp
    native/controller.cpp
    native/friends.cpp
    native/gameserver.cpp
	native/matchmaking.cpp
    native/networking.cpp
    native/networkingmessages.cpp
    native/stats.cpp
	native/ugc.cpp
    native/timeline.cpp
)
target_include_directories(steam.hdll PUBLIC sdk/public)
set_target_properties(steam.hdll PROPERTIES PREFIX "" OUTPUT_NAME steam SUFFIX .hdll)

if (WIN32)
    target_link_libraries(steam.hdll ${CMAKE_CURRENT_SOURCE_DIR}/sdk/redistributable_bin/win64/steam_api64.lib)

    if (BUILD_HASHLINK)
		if (NOT TARGET libhl)
            add_subdirectory(${HL_LIBS_DIR}/hashlink hashlink)
            set_property(TARGET libhl PROPERTY POSITION_INDEPENDENT_CODE ON)
		endif()
		target_link_libraries(steam.hdll libhl)
	else()
        target_include_directories(steam.hdll PUBLIC $ENV{HASHLINKPATH}/include)
        target_link_libraries(steam.hdll $ENV{HASHLINKPATH}/libhl.lib)
    endif()
elseif(APPLE)
    target_link_libraries(steam.hdll ${CMAKE_CURRENT_SOURCE_DIR}/sdk/redistributable_bin/osx/libsteam_api.dylib)

    if (BUILD_HASHLINK)
		if (NOT TARGET libhl)
            add_subdirectory(${HL_LIBS_DIR}/hashlink hashlink)
            set_property(TARGET libhl PROPERTY POSITION_INDEPENDENT_CODE ON)
		endif()
		target_link_libraries(steam.hdll libhl)
	else()
        target_include_directories(steam.hdll PUBLIC ${HLPATH}/include)
        target_link_libraries(steam.hdll ${HLPATH}/lib/libhl.dylib)
    endif()

    find_library(APPLICATION_SERVICES_FRAMEWORK ApplicationServices REQUIRED)
    target_link_libraries(steam.hdll ${APPLICATION_SERVICES_FRAMEWORK})
else()
    target_link_libraries(steam.hdll ${CMAKE_CURRENT_SOURCE_DIR}/sdk/redistributable_bin/linux64/libsteam_api.so)

    if (BUILD_HASHLINK)
        if (NOT TARGET libhl)
            add_subdirectory(${HL_LIBS_DIR}/hashlink hashlink)
            set_property(TARGET libhl PROPERTY POSITION_INDEPENDENT_CODE ON)
        endif()
        target_link_libraries(steam.hdll libhl)
    else()
        target_include_directories(steam.hdll PUBLIC $ENV{HASHLINKPATH}/src)
        target_link_libraries(steam.hdll $ENV{HASHLINKPATH}/libhl.so)
    endif()
endif()

install(TARGETS steam.hdll DESTINATION lib)