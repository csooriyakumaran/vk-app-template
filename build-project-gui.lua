-- build-project-gui.lua

workspace 'vk-app'
    architecture 'x64'
    configurations { 'Debug', 'Release', 'Dist' }
    startproject 'vk-gui-app'

outputdir = '%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}'

IncludeDirs = {}

-- core libraries
IncludeDirs['vk'] = 'core/vk/src'
IncludeDirs['vk_gui'] = 'core/vk/src-platform/gui'
IncludeDirs['vk_win'] = 'core/vk/src-platform/windows'

-- external libraries
IncludeDirs['glfw']   = 'external/glfw/include'
IncludeDirs['glad']   = 'external/glad/include'
IncludeDirs['imgui']  = 'external/imgui'
IncludeDirs['implot'] = 'external/implot'
IncludeDirs['eigen']  = 'external/eigen'
IncludeDirs['stb']    = 'external/stb'
IncludeDirs['spdlog'] = 'external/spdlog/include'


-- external / third-party pre-compiled libraries
LibraryDirs = {}

-- external / third-party pre-compiled libraries
Library = {}


group 'Dependencies'
    include "external/build-glfw.lua"
    include "external/build-glad.lua"
    include "external/build-imgui.lua"
    include "external/build-implot.lua"
group ''


group 'Core'
    include 'core/vk/build-vk-external.lua'
group ''


group 'Application'
    include 'app/app-gui/build-app.lua'
    include 'app/app-cli/build-app.lua'
group ''

newaction {
    trigger = "clean",
    description = "Cleaning build",
    execute = function ()
        print("Removing binaries")
        os.rmdir("./bin")
        os.rmdir("./core/vk/bin")
        os.rmdir("./core/moc2/bin")
        os.rmdir("./external/bin")

        print("Removing object files")
        os.rmdir("./build")
        os.rmdir("./compile_commands")
        os.rmdir("./core/vk/build")
        os.rmdir("./core/moc2/build")
        os.rmdir("./external/build")

        print("Removing project files")
        os.rmdir("./.vs")
        os.remove("*.sln")

        os.remove("app/**.vcxproj")
        os.remove("app/**.vcxproj.filters")
        os.remove("app/**.vcxproj.user")
        os.remove("app/**.vcxproj.FileListAbsolute.txt")
        os.remove("app/**.make")
        os.remove("app/**Makefile")

        os.remove("core/**.vcxproj")
        os.remove("core/**.vcxproj.filters")
        os.remove("core/**.vcxproj.user")
        os.remove("core/**.vcxproj.FileListAbsolute.txt")
        os.remove("core/**.make")
        os.remove("core/**Makefile")

        os.remove("external/*.vcxproj")
        os.remove("external/*.vcxproj.filters")
        os.remove("external/*.vcxproj.user")
        os.remove("external/*.vcxproj.FileListAbsolute.txt")
        os.remove("external/*.make")
        os.remove("external/*Makefile")
        print("Done")
    end
}
