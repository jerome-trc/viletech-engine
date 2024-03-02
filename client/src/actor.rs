//! ECS components for actors (traditionally "map objects" or "mobjs").

use bevy_ecs::{component::Component, entity::Entity};
use fixed::types::I16F16;

use crate::Angle;

#[derive(Debug)]
pub struct Blueprint {
	/// Editor number.
	pub ed_num: i32,
	pub spawn_health: i32,
}

#[derive(Component, Debug, Clone, Copy)]
pub struct Enemy {
	pub flags: EnemyFlags,

	pub last_enemy: Option<Entity>,
	/// How long a monster pursues a target.
	pub pursue: i16,
	/// If non-zero don't attack yet.
	pub react_time: i16,
	pub strafe_count: i16,
	/// Thing being chased/attacked.
	pub target: Option<Entity>,
	/// If >0, the current target will be chased no
	/// matter what (even if shot by another object).
	pub threshold: i16,
}

bitflags::bitflags! {
	#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
	pub struct EnemyFlags: u64 {
		/// Not to be activated by sound; "deaf" monster.
		const AMBUSH = 1;
		/// Just attacked; will take at least one step before attacking again.
		const COOLDOWN = Self::AMBUSH.bits() * 2;
		const CORPSE = Self::COOLDOWN.bits() * 2;
		const COUNT_KILL = Self::CORPSE.bits() * 2;
		const FRIEND = Self::COUNT_KILL.bits() * 2;
		const RESURRECTED = Self::FRIEND.bits() * 2;
		// Just hit; will try to attack right back.
		const RETALIATE = Self::RESURRECTED.bits() * 2;
	}
}

/// Spatial component using 32-bit fixed-point numbers.
#[derive(Component, Debug, Clone, Copy)]
pub struct FxSpace {
	pub flags: SpaceFlags,

	pub x: I16F16,
	pub y: I16F16,
	pub z: I16F16,

	pub prev_x: I16F16,
	pub prev_y: I16F16,
	pub prev_z: I16F16,

	pub vel_x: I16F16,
	pub vel_y: I16F16,
	pub vel_z: I16F16,

	pub angle: Angle,
	pub pitch: Angle,

	pub radius: I16F16,
	pub height: I16F16,

	pub friction: i32,
	pub solid: bool,
}

bitflags::bitflags! {
	#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
	pub struct SpaceFlags: u64 {
		const DROPOFF = 1;
		const FLOAT = Self::DROPOFF.bits() * 2;
		const SOLID = Self::FLOAT.bits() * 2;
		const SHOOTABLE = Self::SOLID.bits() * 2;
	}
}

#[derive(Component, Debug, Clone, Copy)]
pub struct Health {
	pub amount: i32,
}

#[derive(Component, Debug, Clone, Copy)]
pub struct Item {
	pub flags: ItemFlags,
}

bitflags::bitflags! {
	#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
	pub struct ItemFlags: u64 {
		const COLLECTIBLE = 1;
		/// Dropped by a demon, not level spawned.
		/// g.g. ammo "clips" dropped by dying former humans.
		const DROPPED = Self::COLLECTIBLE.bits() * 2;
	}
}

#[derive(Component, Debug, Clone, Copy)]
pub struct Player {
	pub index: u8,
	pub tele_freeze: i16,
}

#[derive(Component, Debug, Clone, Copy)]
pub struct Projectile {
	pub damage: i32,
	pub originator: Option<Entity>,
	/// For seeking missiles.
	pub target: Option<Entity>,
}

#[derive(Component, Debug, Clone, Copy)]
pub struct Render {
	pub alpha: f32,
}

/// Principally for nightmare respawn.
#[derive(Component, Debug, Clone, Copy)]
pub struct SpawnPoint {
	pub x: I16F16,
	pub y: I16F16,
	pub z: I16F16,

	pub tid: i16,
	pub angle: i16,
	pub class: i16,

	pub options: i32,
	pub special: i32,
	pub args: [i32; 5],

	pub gravity: I16F16,
	pub health: I16F16,

	pub alpha: f32,
}

#[derive(Component, Debug, Clone, Copy)]
pub struct Special {
	pub tid: i16,
	pub special: i32,
	pub args: [i32; 5]
}

/// Spatial component using 64-bit floating-point numbers.
#[cfg(any())] // Maybe useful one day?
#[derive(Component, Debug)]
pub struct FlSpace {
	pub angles: DRotator,
	pub height: f64,
	pub pos: DVector3,
	pub radius: f64,
	pub scale: DVector2,
	pub vel: DVector3,
}
