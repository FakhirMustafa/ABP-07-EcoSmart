# Generated file. Do not edit.

cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

set(BINARY_NAME "tubes_abp")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set build type if not specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
endif()

# Define executable
add_executable(${BINARY_NAME}
  "runner/main.cpp"
  "runner/flutter_window.cpp"
  "runner/flutter_window.h"
  "runner/utils.cpp"
  "runner/utils.h"
)

# List plugins
apply_standard_settings(${BINARY_NAME})
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_WINDOWS=1")

# Add Flutter dependencies
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
include(${FLUTTER_MANAGED_DIR}/generated_plugins.cmake)
find_package(Flutter REQUIRED PATHS ${FLUTTER_MANAGED_DIR})

flutter_target_add_flutter_assets(${BINARY_NAME} ${PROJECT_SOURCE_DIR}/data)

# Link Flutter
target_link_libraries(${BINARY_NAME} PRIVATE Flutter::Flutter)

# Fix warning "strncpy unsafe" issue
if (WIN32)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()

# Plugins
include(${FLUTTER_MANAGED_DIR}/generated_plugins.cmake)

