#include "d_imgui.h"

#include "cimgui.h"
#include "s_sound.h"
#include "w_wad.h"

static bool s_imgui_metrics = false;
static bool s_music_player = false;

#ifndef MAKE_ID
#ifndef __BIG_ENDIAN__
#define MAKE_ID(a, b, c, d) ((uint32_t)((a) | ((b) << 8) | ((c) << 16) | ((d) << 24)))
#else
#define MAKE_ID(a, b, c, d) ((uint32_t)((d) | ((c) << 8) | ((b) << 16) | ((a) << 24)))
#endif
#endif

static int musHeaderSearch(const uint8_t* head, int len) {
	len -= 4;

	for (int i = 0; i <= len; ++i) {
		if (head[i + 0] == 'M' && head[i + 1] == 'U' && head[i + 2] == 'S' && head[i + 3] == 0x1A) {
			return i;
		}
	}

	return -1;
}

void imguiFrameStart(void) {
	ImGui_ImplOpenGL3_NewFrame();
	ImGui_ImplSDL2_NewFrame();
	igNewFrame();
}

void imguiFrameFinish(void) {
	if (s_imgui_metrics) {
		igShowMetricsWindow(&s_imgui_metrics);
	}

	igRender();
}

void imguiToggleMusicPlayer(void) {
	s_music_player = !s_music_player;
}

static bool streq(const char* a, const char* b) {
	return strcmp(a, b) == 0;
}

void imguiDrawMusicPlayer(void) {
	if (!s_music_player) {
		return;
	}

	ImVec2 scroll_size = { .x = 400, .y = 800 };
	ImVec2 button_size = { .x = 80, .y = 32 };

	igBegin("Music Player", &s_music_player, 0);
	igBeginChild_Str("Scrolling", scroll_size, 0, 0);

	int32_t walker = 0;

	while ((walker < numlumps) && !streq("RATDJ_ST", W_LumpName(walker))) {
		walker += 1;
	}

	while (!streq("RATDJ_EN", W_LumpName(walker))) {
		const uint8_t* lump = (const uint8_t*)W_LumpByNum(walker);
		int len = W_LumpLength(walker);

		if (len < 4) {
			igText(W_LumpName(walker));
			walker += 1;
			continue;
		}

		const uint32_t* id = (const uint32_t*)lump;

		if (((id[0] == MAKE_ID('M', 'T', 'h', 'd')) || (musHeaderSearch(lump, len) >= 0)) &&
			igButton(W_LumpName(walker), button_size)) {
			S_ChangeMusicByName(W_LumpName(walker), true);
		}

		walker += 1;
	}

	igEndChild();
	igEnd();
}

bool imguiNeedsMouse(void) {
	return s_imgui_metrics || s_music_player;
}
