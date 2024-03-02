//! # VileTech Client
//!
//! The interface via which an end user plays games on the VileTech Engine.

pub mod actor;
pub mod c;
pub mod icon;

use std::path::PathBuf;

use bevy_ecs::world::World;
use clap::Parser;

pub type Angle = u32;

pub struct Core {
	pub world: World,
	pub g_cx: CGlobal,
}

/// Parts of [`Core`] that are FFI-safe.
///
/// See the [`c`] module for many associated functions.
#[repr(C)]
pub struct CGlobal {
	pub no_sfx: bool,
	pub pause: Pause,
}

#[no_mangle]
pub static mut g_cx: *mut CGlobal = std::ptr::null_mut();

bitflags::bitflags! {
	#[repr(transparent)]
	#[derive(Debug, Clone, Copy, PartialEq, Eq)]
	pub struct Pause: i32 {
		const COMMAND = 1 << 0;
		const PLAYBACK = 1 << 1;
		const BUILDMODE = 1 << 2;
	}
}

#[derive(clap::Parser, Debug)]
#[command(name = "VileTech Client")]
#[command(version)]
#[command(about = "Play id Tech 1 games on the VileTech Engine")]
#[command(long_about = "
VileTech Client - Copyright (C) 2024 - jerome-trc

This program comes with ABSOLUTELY NO WARRANTY.

This is free software, and you are welcome to redistribute it under certain
conditions. See the license document that comes with your installation.")]
struct LaunchArgs {
	/// Use original dsda-doom code for demo compatibility.
	#[arg(short, long)]
	legacy: bool,
	/// e.g. DOOM.WAD, DOOM2.WAD, TNT.WAD, PLUTONIA.WAD, freedoom1.wad, freedoom2.wad...
	#[arg(short, long)]
	iwad: PathBuf,
}

#[no_mangle]
pub extern "C" fn rs_main() -> i32 {
	let _args = LaunchArgs::parse();

	let mut core = Core {
		world: World::default(),
		g_cx: CGlobal {
			no_sfx: false,
			pause: Pause::empty(),
		},
	};

	// SAFETY: `core` never leaves this stack frame.
	unsafe {
		g_cx = std::ptr::addr_of_mut!(core.g_cx);
	}

	0
}
