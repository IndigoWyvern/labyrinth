extends Area2D

@onready var entity_id: String = str(self.get_path())
@onready var sprite_2d: Sprite2D = $Sprite2D


var memory: Dictionary = {}

enum EntityState {EXPLORING,INTERACTING,SLEEPING,DEAD}

var hunger: int = 10
var energy: int = 10
var hp: int = 50
var point: Vector2 = Vector2.ZERO
const DEFAULT_AGGRO: int = 0
const SPEED: float = 100
const ROTATION_SPEED:float = 1.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.modulate = _generate_random_rgb_color()
	print(entity_id)
	print(sprite_2d.modulate)

func _generate_random_rgb_color() -> Color:
	return Color(randf(), randf(), randf(),)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_motion(delta)
	#check interactions()
	pass

func get_entity_id()-> String:
	return entity_id


	
func encounter(opponentid)-> void:
	var aggro = get_aggro_from_memory(opponentid)
	#resolve_encounter(aggro)
	#update_memory(opponentid,aggro)
	pass

func get_aggro_from_memory(opponentid)-> int:
	if memory.has(opponentid) == true:
		return memory[opponentid]
	else:
		return DEFAULT_AGGRO

func generate_random_point()-> Vector2:
	return Vector2(randf_range(-1000,1000),randf_range(-1000,1000))


func process_motion(delta)-> void:
	var moving: bool = rand_bool()
	if moving == true: 
		point = generate_random_point()
		var dir_to_point: Vector2 = global_position.direction_to(point)
		var angle_to_point: float = transform.x.angle_to(dir_to_point)
		rotate(sign(angle_to_point) * min(abs(angle_to_point), ROTATION_SPEED * delta))
		position += transform.x * SPEED * delta
	else:
		return
	

func rand_bool()-> bool:
	var cointoss: int = randi_range(0,1)
	if cointoss == 0:
		return false
	else:
		return true
