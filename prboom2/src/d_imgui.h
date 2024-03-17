/// @file
/// @brief ImGui code.

#pragma once

#include <stdint.h>

#define CIMGUI_DEFINE_ENUMS_AND_STRUCTS
#include <cimgui.h>
#include <cimgui_impl.h>

void imguiFrameStart(void);
void imguiFrameFinish(void);

void imguiToggleMusicPlayer(void);
void imguiDrawMusicPlayer(void);

bool imguiNeedsMouse(void);
