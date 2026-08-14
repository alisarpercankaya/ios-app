extends Node
## Tunable gameplay constants shared across systems.

const LANE_COUNT: int = 4
const LANE_WIDTH: float = 2.5
const ROAD_WIDTH: float = LANE_COUNT * LANE_WIDTH
const ROAD_HALF_WIDTH: float = ROAD_WIDTH * 0.5
const LANE_XS: Array[float] = [-3.75, -1.25, 1.25, 3.75]

const BASE_FORWARD_SPEED: float = 12.0
const BOOST_SPEED_MULTIPLIER: float = 1.6

const GRAVITY: float = 20.0

const ROAD_SEGMENT_LENGTH: float = 40.0
const ROAD_SEGMENT_COUNT: int = 8

const TRAFFIC_POOL_SIZE: int = 24
const TRAFFIC_SPAWN_Z: float = -170.0
const TRAFFIC_DESPAWN_Z: float = 15.0
const TRAFFIC_MIN_SPAWN_INTERVAL: float = 0.55
const TRAFFIC_MAX_SPAWN_INTERVAL: float = 1.6
const TRAFFIC_DIFFICULTY_RAMP_DISTANCE: float = 1500.0
const TRAFFIC_SPEED_VARIANCE_MIN: float = -4.0
const TRAFFIC_SPEED_VARIANCE_MAX: float = 2.5
const TRAFFIC_MIN_LANE_GAP: float = 25.0

const COIN_PER_10M: int = 1
const COIN_PER_NEAR_MISS: int = 5


## Extra inset (in viewport pixels) needed to clear notches/home indicators.
## screen_get_usable_rect() is screen-space, only comparable to the viewport
## when the window IS the whole screen - true on a real phone, not in a
## desktop dev window - so this is a no-op off-device.
static func get_safe_area_margin(viewport: Viewport) -> Vector2:
	if not (OS.get_name() == "iOS" or OS.get_name() == "Android"):
		return Vector2.ZERO
	var vp_size: Vector2 = viewport.get_visible_rect().size
	var safe_area: Rect2i = DisplayServer.screen_get_usable_rect()
	return Vector2(
		maxf(0.0, vp_size.x - safe_area.size.x),
		maxf(0.0, vp_size.y - safe_area.size.y)
	)
