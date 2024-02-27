//! Embedded window icon data.

pub static WINDOW_ICON: &[u8] = include_bytes!("../../../client/ICONS/viletech.png");

#[no_mangle]
pub unsafe extern "C" fn window_icon_bytes(size: *mut i32) -> *const u8 {
	*size = WINDOW_ICON.len() as i32;
	WINDOW_ICON.as_ptr()
}
