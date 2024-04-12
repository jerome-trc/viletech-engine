//! # VileTech Client
//!
//! The interface via which an end user plays games on the VileTech Engine.

use std::{
	ffi::{c_char, c_int, CString},
	process::ExitCode,
};

mod actor;
mod icon;

pub(crate) type Angle = u32;

bitflags::bitflags! {
	#[repr(transparent)]
	#[derive(Debug, Clone, Copy, PartialEq, Eq)]
	pub(crate) struct Pause: i32 {
		const COMMAND = 1 << 0;
		const PLAYBACK = 1 << 1;
		const BUILDMODE = 1 << 2;
	}
}

extern "C" {
	#[must_use]
	fn c_main(argc: c_int, argv: *mut *mut c_char) -> c_int;
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
pub(crate) struct LaunchArgs {}

fn main() -> ExitCode {
	let args = std::env::args();
	let mut argv = vec![];

	for arg in args {
		argv.push(CString::new(arg).unwrap().into_raw())
	}

	assert!(!argv.is_empty());

	unsafe {
		match c_main(argv.len() as c_int, argv.as_mut_ptr()) {
			0 => ExitCode::SUCCESS,
			_ => ExitCode::FAILURE,
		}
	}
}
