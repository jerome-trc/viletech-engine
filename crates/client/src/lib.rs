//! # VileTech Client
//!
//! The Rust component of the VileTech Client.

pub mod icon;

use clap::Parser;

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
}

#[no_mangle]
pub extern "C" fn parse_args() {
	let args = LaunchArgs::parse();
}
