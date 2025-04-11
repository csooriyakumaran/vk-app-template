-- build-project-gui.lua

workspace 'vk-app'
    architecture 'x64'
    configurations { 'Debug', 'Release', 'Dist' }
    startproject 'vk-app-gui'

outputdir = '%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}'

IncludeDirs = {}

-- core libraries
IncludeDirs['vk'] = 'core/vk/src'

-- external libraries
IncludeDirs['imgui']  = 'external/imgui'
IncludeDirs['implot'] = 'external/implot'


-- external / third-party pre-compiled libraries
LibraryDirs = {}

-- external / third-party pre-compiled libraries
Library = {}


group 'Dependencies'
    include 'external/imgui'
    include 'external/implot'
group ''


group 'Core'
    include 'core/vk'
group ''


group 'Application'
    include 'app/app-gui/build-app.lua'
group ''

newaction {
    trigger = "clean",
    description = "Cleaning build",
    execute = function ()
        print("Removing binaries")
        os.rmdir("./bin")
        os.rmdir("./core/vk/bin")
        os.rmdir("./core/moc2/bin")
        print("Removing object files")
        os.rmdir("./build")
        os.rmdir("./compile_commands")
        os.rmdir("./core/vk/build")
        os.rmdir("./core/moc2/build")
        print("Removing project files")
        os.rmdir("./.vs")
        os.remove("**.sln")
        os.remove("**.vcxproj")
        os.remove("**.vcxproj.filters")
        os.remove("**.vcxproj.user")
        os.remove("**.vcxproj.FileListAbsolute.txt")
        os.remove("**.make")
        os.remove("**Makefile")
        print("Done")
    end
}
