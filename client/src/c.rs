//! C shim functions.

use crate::{g_cx, CGlobal, Pause};

impl CGlobal {
	#[no_mangle]
	#[must_use]
	pub unsafe extern "C" fn rs_paused() -> bool {
		!(*g_cx).pause.is_empty()
	}

	#[no_mangle]
	#[must_use]
	pub unsafe extern "C" fn rs_mask_pause() -> i32 {
		let mask = (*g_cx).pause.difference(Pause::COMMAND);
		(*g_cx).pause &= Pause::COMMAND;
		mask.bits()
	}
}
