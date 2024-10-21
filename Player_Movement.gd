extends CharacterBody3D	# In Godot, the line extends CharacterBody3D is used at the beginning of a script to indicate that the script is a subclass of the CharacterBody3D class. This allows you to inherit the functionality of the CharacterBody3D


@export	var speed = 5.0					# @export: keyword is used to expose variables in your script to the editor
@export var jump_velocity = 4.5
@export var surfing_speed_value = 3.0;

@onready var head: Node3D = $Head		# initializes variables with node references after the node is ready, ensuring the referenced nodes are available in the scene.
@onready var eye: Camera3D = $Head/Eye	#

func _ready() -> void:									# _ready(): runs at the beginning of a scene only one time
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)		# Input.set_mouse_mode()
														# Input.MOUSE_MODE_CAPTURED: sets the mouse mode to be non visible
func _physics_process(delta: float) -> void: 	# symbol: 			to denote return types for functions like void
	# Add the gravity.							# keyword: 			function doesn't return any value
	if not is_on_floor():						# is_on_floor(): 	returns true if the character is on the ground and false otherwise.
		velocity += get_gravity() * delta		# get_gravity():	get_gravity() returns a Vector3 representing the gravity vector applied to the character
												# delta: is the time in seconds since the last frame, used for consistent movements and animations.
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("left", "right", "forward", "backward") 											# := type declaration that cannot be changed
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()								# transform.basis: Represents the orientation (rotation) and scaling of the object.
	if direction:								# default: true															# Vector3(): x, y, and z
		velocity.x = direction.x * speed		# x (will be equal to 1 if it is called after .normalized()) * SPEED	# .normalized(): In Godot, the .normalized() method for a Vector3 (or Vector2) returns a unit vector in the same direction, meaning it has the same direction but a magnitude (length) of 1.
		velocity.z = direction.z * speed		# z (will be equal to 1 if it is called after .normalized()) * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta * surfing_speed_value) 									# negative surfing_speed_value increases
		velocity.z = move_toward(velocity.z, 0, speed * delta * surfing_speed_value) 									# negative surfing_speed_value increases 

	move_and_slide() 							# move_and_slide() is a function you call in your game to make an object move and automatically slide along walls or surfaces when it collides with them.
