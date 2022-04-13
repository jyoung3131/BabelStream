
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

    list(APPEND CMAKE_MODULE_PATH "${cupla_ROOT}")
    list(APPEND CMAKE_MODULE_PATH "${cupla_ROOT}/cmake")
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/Modules")
    find_package(cupla REQUIRED)

    #Point to directory that contains cuda_to_cupla.h in your CUPLA build to avoid compilation errors
    set(CUPLA_INCLUDE_DIR ${cupla_ROOT}/include)
    #Also add the Alpaka and Boost includes - note that Boost 1.65 or greater is required
    set(ALPAKA_INCLUDE_DIR ${cupla_ROOT}/alpaka/include)
    set(BOOST_INCLUDE_DIR "$ENV{BOOST_ROOT}/include")
    include_directories(${CUPLA_INCLUDE_DIR} ${ALPAKA_INCLUDE_DIR} ${BOOST_INCLUDE_DIR})

endmacro()
