//! # VileTech Client
//!
//! The interface via which an end user plays games on the VileTech Engine.

pub mod icon;

use std::path::PathBuf;

use bevy_ecs::world::World;
use clap::Parser;

#[no_mangle]
pub static mut g_cx: *mut CGlobal = std::ptr::null_mut();

pub struct Core {
	pub world: World,
	pub g_cx: CGlobal,
}

/// Parts of [`Core`] that are FFI-safe.
#[repr(C)]
pub struct CGlobal {
	pub no_sfx: bool,
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
		g_cx: CGlobal { no_sfx: false },
	};

	unsafe {
		g_cx = std::ptr::addr_of_mut!(core.g_cx);
	}

	0
}
