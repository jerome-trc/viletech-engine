use std::path::{Path, PathBuf};

fn main() {
	println!("cargo:rerun-if-changed=src");

	if cfg!(target_os = "linux") {
		println!("cargo:rustc-link-search=/usr/local/lib");
		println!("cargo:rustc-link-search=/usr/lib/x86_64-linux-gnu");
	}

	if cfg!(any(target_os = "macos", target_os = "freebsd")) {
		println!("cargo:rustc-link-lib=static=c++");
	} else {
		println!("cargo:rustc-link-lib=static=stdc++");
	}

	println!("cargo:rustc-link-lib=dl");
	println!("cargo:rustc-link-lib=dumb");
	println!("cargo:rustc-link-lib=fluidsynth");
	println!("cargo:rustc-link-lib=GL");
	println!("cargo:rustc-link-lib=GLU");
	println!("cargo:rustc-link-lib=m");
	println!("cargo:rustc-link-lib=mad");
	println!("cargo:rustc-link-lib=ogg");
	println!("cargo:rustc-link-lib=pthread");
	println!("cargo:rustc-link-lib=portmidi");
	println!("cargo:rustc-link-lib=SDL2-2.0");
	println!("cargo:rustc-link-lib=SDL2_image");
	println!("cargo:rustc-link-lib=SDL2_mixer");
	println!("cargo:rustc-link-lib=vorbis");
	println!("cargo:rustc-link-lib=vorbisfile");
	println!("cargo:rustc-link-lib=z");
	println!("cargo:rustc-link-lib=zip");

	let libdir = if std::env::var("PROFILE").unwrap() == "release" {
		Path::new(env!("CARGO_WORKSPACE_DIR")).join("build/src/Release")
	} else {
		Path::new(env!("CARGO_WORKSPACE_DIR")).join("build/src/Debug")
	};

	println!("cargo:rustc-link-search={}", libdir.display());
	println!("cargo:rustc-link-lib=static=viletech");

	generate_c_bindings();
	generate_rust_bindings();
}

// C binding generation ////////////////////////////////////////////////////////

fn generate_c_bindings() {
	let mut config = cbindgen::Config::default();

	#[cfg(any())]
	{
		config.language = cbindgen::Language::Cxx;
		config.include_version = true;
		config.namespace = Some("vtec".to_string());
		config.no_includes = true;
		config.pragma_once = true;
		config.macro_expansion.bitflags = true;
		config.structure.associated_constants_in_body = true;
		config.function.must_use = Some("[[nodiscard]]".to_string());

		gen_header(&mut config, "", "viletech.rs.hpp", &[]);
	}

	{
		config.language = cbindgen::Language::C;
		config.export.prefix = Some("rs_".to_string());
		config.include_version = true;
		config.pragma_once = true;
		config.macro_expansion.bitflags = true;
		config.cpp_compat = true;

		gen_header(&mut config, "", "viletech.rs.h", &["CGlobal"]);
	}
}

fn gen_header(
	config: &mut cbindgen::Config,
	header: &'static str,
	rel_path: &'static str,
	symbols: &'static [&'static str],
) {
	if !header.is_empty() {
		config.header = Some(format!("//! @file\n//! @brief {header}"));
	}

	for sym in symbols {
		config.export.include.push(sym.to_string());
	}

	cbindgen::generate_with_config(std::env::var("CARGO_MANIFEST_DIR").unwrap(), config.clone())
		.expect("binding generation failed")
		.write_to_file(
			Path::new(env!("CARGO_WORKSPACE_DIR"))
				.join("build")
				.join(rel_path),
		);

	config.export.include.clear();
	config.header = None;
}

// Rust binding generation /////////////////////////////////////////////////////

fn generate_rust_bindings() {
	let mut headers = vec![];

	let src_dir = Path::new(env!("CARGO_WORKSPACE_DIR")).join("engine/src");

	headers.push(src_dir.join("d_main.h"));

	let mut builder = bindgen::Builder::default();

	for header in headers {
		builder = builder.header(header.to_string_lossy().as_ref());
	}

	let out_path = PathBuf::from(std::env::var("OUT_DIR").unwrap()).join("bindings.rs");

	builder
		.parse_callbacks(Box::new(bindgen::CargoCallbacks::new()))
		.generate()
		.expect("binding generation failed")
		.write_to_file(&out_path)
		.expect("binding writing failed");

	// Make a copy in an easy-to-access location for assessment.
	std::fs::copy(
		out_path,
		Path::new(env!("CARGO_WORKSPACE_DIR")).join("target/bindings.rs"),
	)
	.expect("failed to copy generated bindings to `/target`");
}
