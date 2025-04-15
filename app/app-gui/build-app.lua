project "vk-gui-app" 
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
        "../../%{IncludeDirs.vk_gui}",

        -- external dependencies
        "../../%{IncludeDirs.eigen}",
        "../../%{IncludeDirs.glfw}",
        "../../%{IncludeDirs.glad}",
        "../../%{IncludeDirs.imgui}",
        "../../%{IncludeDirs.implot}",
        "../../%{IncludeDirs.stb}",
        "../../%{IncludeDirs.spdlog}",
        "../../%{IncludeDirs.yamlcpp}",

    }

    links {

        -- core
        "vk",

        -- external dependencies
        "ImGui",
        "ImPlot",
        "yaml-cpp",
    }

    defines {
        "_USE_MATH_DEFINES",
        "SPDLOG_USE_STD_FORMAT",
        'YAML_CPP_STATIC_DEFINE',
        'YAML_CPP_NO_CONTRIB',
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
        optimize "Full" 
        symbols "On" 

    filter "configurations:Dist" 
        kind "WindowedApp"
        defines { "DIST" }
        runtime "Release" 
        optimize "Full" 
        symbols "Off"
