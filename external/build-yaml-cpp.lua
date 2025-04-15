project 'yaml-cpp'
    kind 'StaticLib'
    language 'C++'
    cppdialect 'C++20'

    targetdir  ( 'bin/' .. outputdir .. '/%{prj.name}' )
    objdir   ( 'build/' .. outputdir .. '/%{prj.name}' )

    files 
    {
        'yaml-cpp/src/**.h',
        'yaml-cpp/src/**.cpp',

        'yaml-cpp/include/**.h',
    }

    includedirs
    {
        'yaml-cpp/include'
    }

    defines
    {
        'YAML_CPP_STATIC_DEFINE',
        'YAML_CPP_NO_CONTRIB',
    }

    filter 'system:windows'
        systemversion 'latest'
        staticruntime 'off'

    filter 'system:linux'
        pic 'On'
        systemversion 'latest'
        staticruntime 'off'

    filter 'configurations:Debug'
        runtime 'Debug'
        symbols 'on'


    filter 'configurations:Release'
        runtime 'Release'
        symbols 'on'
        optimize 'full'

    filter 'configurations:Dist'
        runtime 'Release'
        symbols 'off'
        optimize 'full'
