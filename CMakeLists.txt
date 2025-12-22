cmake_minimum_required(VERSION 3.0)
project(SDL2_TTF C)

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/mk/cmake")

option(SDL2TTF_INSTALL "Install target for SDL2_ttf." OFF)
option(SDL2TTF_RAQM "Build with RAQM" OFF)

add_library(SDL2_ttf SDL_ttf.c version.rc)

set_target_properties(SDL2_ttf PROPERTIES DEFINE_SYMBOL SDL2_EXPORTS)
target_include_directories(SDL2_ttf PUBLIC ${PROJECT_SOURCE_DIR})

if(TARGET RAQM)
  message(STATUS "Compiling SDL_ttf with RAQM")
  set(SDL2TTF_RAQM ON)
else()
  message(STATUS "SDL_ttf will not be compiled with RAQM")
endif()

if(SDL2TTF_RAQM AND (TARGET RAQM))
  target_compile_definitions(SDL2_ttf PRIVATE HAVE_RAQM=1)
  target_link_libraries(SDL2_ttf PRIVATE RAQM)
endif()

target_link_libraries(SDL2_ttf PRIVATE SDL2 Freetype)

include(GNUInstallDirs)
install(TARGETS SDL2_ttf
  EXPORT sdl2_ttf-targets
  RUNTIME DESTINATION bin
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib)

if(SDL2TTF_INSTALL)  
  if(NOT DEFINED SDL_TTF_SKIP_HEADERS)
    install(FILES SDL_ttf.h DESTINATION include/SDL2)
  endif()
  
  # CMake integration
  configure_file(sdl2_ttf-config.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/sdl2_ttf-config.cmake" @ONLY)
  install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/sdl2_ttf-config.cmake"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/SDL2_ttf/")
  export(TARGETS SDL2_ttf
    FILE "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/sdl2_ttf-targets.cmake")
  export(PACKAGE SDL2_ttf)
  install(EXPORT sdl2_ttf-targets
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/SDL2_ttf/")
endif()

message(STATUS "Link-time dependencies:")
message(STATUS "  " ${SDL_LIBRARY})
message(STATUS "  " ${FREETYPE_LIBRARY})
