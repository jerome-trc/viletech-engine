// Emacs style mode select   -*- C -*-

#include <cstdlib>
#include <signal.h>
#include <unistd.h>

extern "C" {
#include "config.h"
#include "lprintf.h"
#include "m_misc.h"

#include "d_main.h"
#include "i_system.h"
#include "i_video.h"
#include "z_zone.h"
#include "lprintf.h"
#include "doomstat.h"
#include "g_game.h"
#include "m_misc.h"
#include "i_sound.h"
#include "lprintf.h"

#include "e6y.h"

#include "dsda/args.h"
#include "dsda/analysis.h"
#include "dsda/args.h"
#include "dsda/endoom.h"
#include "dsda/signal_context.h"
#include "dsda/split_tracker.h"
#include "dsda/text_file.h"
#include "dsda/time.h"
#include "dsda/wad_stats.h"
#include "dsda/zipfile.h"
}

#include "viletech.rs.hpp"
#include "core.hpp"

/* Most of the following has been rewritten by Lee Killough
 *
 * killough 4/13/98: Make clock rate adjustable by scale factor
 * cphipps - much made static
 */

extern int signal_context;

static volatile sig_atomic_t s_interrupted = 0;

/// @fn signal_handler
static void signal_handler(int s) {
	char buf[2048];

	signal(s, SIG_IGN); /* Ignore future instances of this signal.*/

	// Terminal Interrupt
	if (s == 2)
		I_DisableMessageBoxes();

	I_SigString(buf, sizeof(buf), s);

	I_Error(
		"The game has crashed!\n"
		"Please report the following information: %s (0x%04x)",
		buf, signal_context
	);
}

/// @fn interrupt_handler
static void interrupt_handler(int s) {
	(void)s;
	s_interrupted = 1;
}

/// Schedule a function to be called when the program exits.
/// If run_if_error is true, the function is called if the exit
/// is due to an error (I_Error).
/// @copyright 2005-2014 Simon Howard
struct AtExitListEntry;

struct AtExitListEntry final {
	atexit_func_t func;
	bool run_on_error;
	AtExitListEntry* next;
	const char* name;
};

/// @fn essential_quit
static void essential_quit() {
	if (demorecording) {
		G_CheckDemoStatus();
	}

	dsda_ExportTextFile();
	dsda_WriteAnalysis();
	dsda_WriteSplits();
	dsda_SaveWadStats();
	// We need to close out all wad handles/memory mappings before we can remove
	// temporary wads on Windows
	// Read Endoom before dumping the wads!
	dsda_CacheEndoom();
	W_Shutdown();
	dsda_CleanZipTempDirs();
}

/// @fn quit
static void quit() {
	M_SaveDefaults();
	dsda_DumpEndoom();
}

/// @fn set_process_priority
void set_process_priority() {
	int process_priority = dsda_IntConfig(dsda_config_process_priority);

	if (process_priority) {
		const char* errbuf = NULL;

#ifdef _WIN32
		{
			DWORD dwPriorityClass = NORMAL_PRIORITY_CLASS;

			if (process_priority == 1)
				dwPriorityClass = HIGH_PRIORITY_CLASS;
			else if (process_priority == 2)
				dwPriorityClass = REALTIME_PRIORITY_CLASS;

			if (SetPriorityClass(GetCurrentProcess(), dwPriorityClass) == 0) {
				errbuf = WINError();
			}
		}
#else
		return;
#endif

		if (errbuf == NULL) {
			lprintf(
				LO_INFO, "I_SetProcessPriority: priority for the process is %d\n", process_priority
			);
		} else {
			lprintf(
				LO_ERROR, "I_SetProcessPriority: failed to set priority for the process (%s)\n",
				errbuf
			);
		}
	}
}

/// @fn main
int main(int argc, char* argv[]) {
	(void)argc;
	(void)argv;

	auto core = Core::create();
	vtec::parse_args();

	lprintf(LO_DEBUG, "M_LoadDefaults: Load system defaults.\n");
	M_LoadDefaults(); // Load before initializing other systems.
	lprintf(LO_DEBUG, "\n");

	/*
		killough 1/98:

		This fixes some problems with exit handling
		during abnormal situations.

		The old code called I_Quit() to end program,
		while now I_Quit() is installed as an exit
		handler and exit() is called to exit, either
		normally or abnormally. Seg faults are caught
		and the error handler is used, to prevent
		being left in graphics mode or having very
		loud SFX noise because the sound card is
		left in an unstable state.
	*/

	I_AtExit(essential_quit, true, "I_EssentialQuit", exit_priority_first);
	I_AtExit(quit, false, "I_Quit", exit_priority_last);

#ifndef PRBOOM_DEBUG
	if (!dsda_Flag(dsda_arg_sigsegv)) {
		signal(SIGSEGV, signal_handler);
	}

	signal(SIGFPE, signal_handler);
	signal(SIGILL, signal_handler);
	signal(SIGABRT, signal_handler);

	signal(SIGTERM, interrupt_handler);
	signal(SIGINT, interrupt_handler);
#endif

	// Priority class for the prboom-plus process
	set_process_priority();

	/* cphipps - call to video specific startup code */
	I_PreInitGraphics();

	D_DoomMain();

	return EXIT_SUCCESS;
}
