extends CharacterBody2D


@onready var entity_id: String = str(self.get_path())
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var wall_detector: RayCast2D = $WallDetector
@onready var timer: Timer = $Timer
@onready var entity_no: Label = $EntityNo


var memory: Dictionary = {}

enum EntityState {EXPLORING,INTERACTING,SLEEPING,DEAD}

@export var hunger: int = 10
@export var energy: int = 10
@export var hp: int = 50
@export var speed: int = 100

var point: Vector2 = Vector2.ZERO
#var can_detect_wall: bool = true
var moving: bool = true



const DEFAULT_AGGRO: int = 0
const ROTATION_SPEED:float = 5
const PREFIX: String ="/root/Level/Entities/Entity"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_entity_number()
	rotate(randf_range(-360,360))
	sprite_2d.modulate = _generate_random_rgb_color()
	
	

func set_entity_number()-> void:
	var entity_number = entity_id.erase(0,27)
	entity_no.text = entity_number



func _generate_random_rgb_color() -> Color:
	return Color(randf(), randf(), randf(),)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	process_motion(delta)
	#check interactions()
	move_and_slide()
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

func generate_random_point()-> void:
	point = Vector2(randf_range(-10000,10000),randf_range(-10000,10000))
	


func process_motion(delta)-> void:
	var dir_to_point: Vector2 = global_position.direction_to(point)
	var angle_to_point: float = transform.x.angle_to(dir_to_point)
	
	generate_random_point()
	if moving == true : 
		rotate(sign(angle_to_point) * min(abs(angle_to_point), ROTATION_SPEED * delta))
		position += transform.x * speed * delta
		if  wall_detector.is_colliding() == true:
			timer.start()
	else:
		return
	

func rand_bool()-> bool:
	var cointoss: int = randi_range(0,1)
	if cointoss == 0:
		return false
	else:
		return true


func _on_timer_timeout() -> void:
	generate_random_point()
	print( entity_id, " Ran into a wall")
