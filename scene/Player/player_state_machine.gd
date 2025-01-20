extends AnimationTree

enum {
	IDLE,
	WALK,
	PUNCH,
	EXIT
}

var state

func _ready():
	state = IDLE

func change_state_idle():
	state = IDLE

func change_state_walk():
	state = WALK

func change_state_punch():
	state = PUNCH

func update_blend_value(x,y):
	match state:
		IDLE:
			set("parameters/Idle/blend_position",Vector2(x,-y))
		WALK:
			set("parameters/Walk/blend_position",Vector2(x,-y))
		PUNCH:
			set("parameters/Punch/blend_position",Vector2(x,-y))
			
func is_playing():
	return get("parameters/playback").is_playing()
