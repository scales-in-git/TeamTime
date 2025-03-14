extends Timer

@export var min_time: float = 1.0
@export var max_time: float = 5.0

func start_random():
    var time = randf_range(min_time, max_time)
    start(time)

func _ready():
    if autostart:
        var time = randf_range(min_time, max_time)
        wait_time = time