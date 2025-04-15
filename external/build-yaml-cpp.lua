project 'yaml-cpp'
    kind 'StaticLib'
    language 'C++'
    cppdialect 'C++20'

    targetdir  ( 'bin/' .. outputdir .. '/%{prj.name}' )
    objdir   ( 'build/' .. outputdir .. '/%{prj.name}' )

    files 
    {
        'src/**.h',
        'src/**.cpp',

        'include/**.h',
    }

    includedirs
    {
        'include'
    }

    filter 'system:windows'
        systemversion 'latest'
        staticruntime 'off'

    filter 'system:linux'
        pic 'On'
        systemversion 'latest'
        staticruntime 'off'

    filter 'configuration:Debug'
        runtime 'Debug'
        symbols 'on'


    filter 'configuration:Release'
        runtime 'Release'
        symbols 'on'
        optimize 'full'

    filter 'configuration:Dist'
        runtime 'Release'
        symbols 'off'
        optimize 'full'
