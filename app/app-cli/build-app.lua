project "vk-cli-app" 
    kind "ConsoleApp" 
    language "C++" 
    cppdialect "C++20" 
    staticruntime "off"

    targetdir ("../../bin/" .. outputdir .. "/%{prj.name}")
    objdir ("../../build/" .. outputdir .. "/%{prj.name}")

    files {
        "src/**.h",
        "src/**.cpp",
    }

    includedirs {
        -- application
        "src",

        -- core
        "../../%{IncludeDirs.vk}",
        "../../%{IncludeDirs.vk_cli}",

        -- external dependencies
        "../../%{IncludeDirs.eigen}",
        "../../%{IncludeDirs.spdlog}",


    }

    links {

        -- core
        "vk",

        -- external dependencies
    }

    defines {
        "_USE_MATH_DEFINES",
        "SPDLOG_USE_STD_FORMAT",
        "NO_ENTRY_POINT"
    }

    filter "system:windows" 
        systemversion "latest" 
        defines { "PLATFORM_WINDOWS" }
        includedirs
        {
            "../../%{IncludeDirs.vk_win}",
        }

    filter "configurations:Debug" 
        defines { "DEBUG" }
        runtime "Debug" 
        symbols "On" 

    filter "configurations:Release" 
        defines { "RELEASE" }
        runtime "Release" 
        optimize "Off" 
        symbols "On" 

    filter "configurations:Dist" 
        kind "WindowedApp"
        defines { "DIST" }
        runtime "Release" 
        optimize "Full" 
        symbols "Off"
