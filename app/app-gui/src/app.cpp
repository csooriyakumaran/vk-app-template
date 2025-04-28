#include "vk/types/primitive.h" 

#include "vk/core/log.h"
#include "vk/core/application.h"
#include "vk/core/entry-point.h"
#include "vk/core/procedure.h"

#include "vk/ui/console.h"
#include "vk/render/shader.h"
#include "vk/render/renderer.h"

#include "imgui.h"
#include "implot.h"

#include "yaml-cpp/yaml.h"
#include "glad/glad.h"

#include <string_view>
#include <format>


static u32 s_compute_shader = -1;
static const std::filesystem::path s_compute_shader_path = "shaders/compute.glsl";

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

    void draw_render_viewport();
    vk::Texture m_texture;
    vk::FrameBuffer m_fb;

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

    s_compute_shader = vk::create_compute_shader(s_compute_shader_path);
    ASSERT( s_compute_shader != -1, "Compute shader failed");

    u32 width = vk::Application::get().get_window().get_width();
    u32 height = vk::Application::get().get_window().get_height();
    m_texture = vk::create_texture(width, height);
    m_fb = vk::create_framebuffer_with_texture(m_texture);

}

void MainProc::draw_render_viewport()
{
    ImGui::Begin("Render Viewport");


    int width = (int)ImGui::GetContentRegionAvail().x;
    int height = (int)ImGui::GetContentRegionAvail().y;
    
    if (width != m_texture.width || height != m_texture.height)
    {
        ::glDeleteTextures(1, &m_texture.handle);

        m_texture = vk::create_texture(width, height);
        vk::attach_texture_to_framebuffer(m_fb, m_texture);
    }

    { // compute
        ::glUseProgram(s_compute_shader);
        ::glBindImageTexture(0, m_fb.color_attachement.handle, 0, GL_FALSE, 0, GL_WRITE_ONLY, GL_RGBA32F);

        const GLuint workgroup_size_x = 16;
        const GLuint workgroup_size_y = 16;

        GLuint num_groups_x = (width + workgroup_size_x - 1) / workgroup_size_x;
        GLuint num_groups_y = (height + workgroup_size_y - 1) / workgroup_size_y;

        ::glDispatchCompute(num_groups_x, num_groups_y, 1);

        ::glMemoryBarrier(GL_SHADER_IMAGE_ACCESS_BARRIER_BIT);

    }

    { // Blit
        // vk::blit_framebuffer_to_swapchain(m_fb);
    }
    
    ImGui::Image((ImTextureID)m_texture.handle, {(float)m_texture.width, (float)m_texture.height});

    ImGui::End();

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

    draw_render_viewport();

    ImGuiIO& io = ImGui::GetIO();

    if ( ImGui::IsKeyDown(ImGuiKey_ModCtrl) & ImGui::IsKeyPressed(ImGuiKey_Minus) )
        io.FontGlobalScale -= 0.1f;
    if ( ImGui::IsKeyDown(ImGuiKey_ModCtrl) & ImGui::IsKeyPressed(ImGuiKey_Equal) )
        io.FontGlobalScale += 0.1f;
    if ( ImGui::IsKeyDown(ImGuiKey_R))
        s_compute_shader = vk::reload_compute_shader(s_compute_shader, s_compute_shader_path);
    // vk::Application& app = vk::Application::get();
    // app.close();

}

//- this must be implemented in the client application
vk::Application* vk::create_application(int argc, char** argv)
{
    //- define the application specification
    vk::ApplicationSpecification spec;
    spec.title = "Application Name";

    spec.icon_path = "res/ICON.png";
    spec.transparent = true;
    spec.window_theme = vk::WindowTheme::System;

    vk::Application* app = new vk::Application(spec);
    std::shared_ptr<MainProc> proc = std::make_shared<MainProc>();

    app->load_procedure(proc);

    app->set_menu_draw_fn([&](){
        if (ImGui::BeginMenu("FILE"))
        {
            if (ImGui::MenuItem("Exit", "Alt-F4"))
                app->close();

            ImGui::EndMenu();
        }
    });

    app->set_statusline_fn([&](){
        ImGuiIO& io = ImGui::GetIO();
        std::string status = std::format("Application average {:.3f} ms/frame ({:.1f} FPS)", 1000.0f/io.Framerate, 1.0f*io.Framerate);
        ImGui::SetCursorPosX(
            ImGui::GetCursorPosX() + ImGui::GetContentRegionAvail().x -
            ImGui::CalcTextSize(status.c_str()).x - 7.0f
        );
        ImGui::Text(status.c_str());
    });


    return app;
}
