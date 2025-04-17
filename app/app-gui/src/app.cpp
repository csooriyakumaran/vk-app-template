#include "vk/types/primitive.h" 

#include "vk/core/log.h"
#include "vk/core/application.h"
#include "vk/core/entry-point.h"
#include "vk/core/procedure.h"

#include "vk/ui/console.h"

#include "imgui.h"
#include "implot.h"

#include "yaml-cpp/yaml.h"

#include <string_view>

class MainProc : public vk::Procedure
{
public:
    //- called once when proc is pushed to Application proc stack
    virtual void attach() override;

    //- called once when proc is popped off the stack (usually at the end of the program)
    virtual void detach() override;

    //- called every application frame
    virtual void update(const double dt) override;

    //- called every application frame after update
    virtual void render() override;

private:
    vk::ui::Console m_console;
    vk::ui::ConsoleLog m_log;

};

void MainProc::attach()
{
    LOG_TRACE_TAG("MainProc::attach", "Hello, world!");
    LOG_DEBUG_TAG("MainProc::attach", "Hello, world!");
    LOG_INFO_TAG("MainProc::attach", "Hello, world!");
    LOG_WARN_TAG("MainProc::attach", "Hello, world!");
    LOG_ERROR_TAG("MainProc::attach", "Hello, world!");

    m_console.set_message_send_callback(
        [&](std::string_view msg)
        {
            LOG_INFO(msg);
            m_console.add_message_italic_tagged("input: ", msg);
        }
    );

    m_console.add_message_italic_tagged("INFO", "Hello, World!");

    YAML::Node cfg = YAML::LoadFile("data/cfg.yaml");

    if (cfg["string"])
        LOG_INFO("string: {}", cfg["string"].as<std::string>());

    if (cfg["float"])
    {
        LOG_INFO("float as f32: {}", cfg["float"].as<f32>());
        LOG_INFO("float as f64: {}", cfg["float"].as<f64>());
    }

    if (cfg["exp"])
    {
        LOG_INFO("exp as f32: {}", cfg["exp"].as<f32>());
        LOG_INFO("exp as f64: {}", cfg["exp"].as<f64>());
    }
}

void MainProc::detach()
{
    LOG_INFO_TAG("MainProc::detach", "Goodbye, world!");
}

void MainProc::update(const double dt)
{
    //- your application code goes here
}

void MainProc::render()
{
    ImGui::ShowDemoWindow();
    ImPlot::ShowDemoWindow();
    m_console.render();
    m_log.render();

    // vk::Application& app = vk::Application::get();
    // app.close();

}

//- this must be implemented in the client application
vk::Application* vk::create_application(int argc, char** argv)
{
    //- define the application specification
    vk::ApplicationSpecification spec;
    spec.title = "vk Application";
    spec.theme = "Aiolos";
    spec.icon_path = "res/ICON.png";

    vk::Application* app = new vk::Application(spec);
    std::shared_ptr<MainProc> proc = std::make_shared<MainProc>();

    app->load_procedure(proc);

    return app;
}
