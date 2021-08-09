
register_flag_optional(CMAKE_CXX_COMPILER
        "Any CXX compiler that is supported by CMake detection, this is used for host compilation"
        "c++")

register_flag_optional(CUPLA_EXTRA_FLAGS
	"Additional CUPLA flags appended after main CUPLA flags"
        "")


macro(setup)

    # XXX CMake 3.18 supports CMAKE_CUDA_ARCHITECTURES/CUDA_ARCHITECTURES but we support older CMakes
    if(POLICY CMP0104)
        cmake_policy(SET CMP0104 OLD)
    endif()

    #Find CUPLA specified from the environment variable
    set(cupla_ROOT "$ENV{CUPLA_ROOT}" CACHE STRING  "The location of the cupla library")

    list(APPEND CMAKE_MODULE_PATH "${CUPLA_ROOT}")
    list(APPEND CMAKE_MODULE_PATH "${CUPLA_ROOT}/cmake")
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/Modules")
    find_package(cupla REQUIRED)

    #enable_language(CUPLA)

    #Point to directory that contains cuda_to_cupla.h in your CUPLA build to avoid compilation errors
    #target_include_directories(${EXE_NAME} PRIVATE ${CUPLA_ROOT}/include)

    # add -forward-unknown-to-host-compiler for compatibility reasons
    set(CMAKE_CUPLA_FLAGS ${CMAKE_CUPLA_FLAGS} "" ${CUPLA_EXTRA_FLAGS})

    # CMake defaults to -O2 for CUDA at Release, let's wipe that and use the global RELEASE_FLAG
    # appended later
    wipe_gcc_style_optimisation_flags(CMAKE_CUPLA_FLAGS_${BUILD_TYPE})
   
    message(STATUS "CUPLA flags: ${CMAKE_CUPLA_FLAGS} ${CMAKE_CUPLA_FLAGS_${BUILD_TYPE}}")

endmacro()
