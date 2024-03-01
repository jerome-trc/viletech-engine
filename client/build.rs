use std::path::{Path, PathBuf};

fn main() {
	println!("cargo:rerun-if-changed=src");
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
