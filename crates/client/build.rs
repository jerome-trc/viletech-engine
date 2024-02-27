use std::path::Path;

fn main() {
	let mut config = cbindgen::Config::default();
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
		.write_to_file(Path::new("../../build").join(rel_path));

	config.export.include.clear();
	config.header = None;
}
