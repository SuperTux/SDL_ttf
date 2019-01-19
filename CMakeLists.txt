# Taken from https://github.com/Microsoft/vcpkg/blob/2ad118a2532e99a78c41dffa1b9648e7eca20a95/ports/sdl2-ttf/CMakeLists.txt

cmake_minimum_required(VERSION 3.0)
project(SDL2_TTF C)

find_path(SDL_INCLUDE_DIR SDL2/SDL.h)
find_library(SDL_LIBRARY NAMES SDL2d SDL2)
find_package(Freetype REQUIRED)

add_library(SDL2_ttf SDL_ttf.c version.rc)

set_target_properties(SDL2_ttf PROPERTIES DEFINE_SYMBOL SDL2_EXPORTS)
target_include_directories(SDL2_ttf PRIVATE ${SDL_INCLUDE_DIR}/SDL2 ${FREETYPE_INCLUDE_DIR_ft2build})
if(WITH_RAQM)
    add_definitions(-DHAVE_RAQM=1)
    target_include_directories(SDL2_ttf PRIVATE ${RAQM_INCLUDE_DIR})
    target_link_libraries(SDL2_ttf PUBLIC ${RAQM_LIBRARIES})
endif()
target_link_libraries(SDL2_ttf PRIVATE ${SDL_LIBRARY} ${FREETYPE_LIBRARY})

install(TARGETS SDL2_ttf
    RUNTIME DESTINATION bin
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib)

if(NOT DEFINED SDL_TTF_SKIP_HEADERS)
    install(FILES SDL_ttf.h DESTINATION include/SDL2)
endif()

message(STATUS "Link-time dependencies:")
message(STATUS "  " ${SDL_LIBRARY})
message(STATUS "  " ${FREETYPE_LIBRARY})
