extends CharacterBody2D

@onready var animation: AnimationPlayer = get_node("AnimationPlayer")
@onready var dmg_animation: AnimationPlayer = get_node("DmgAnimationPlayer")
@onready var texture: Sprite2D = get_node("Texture")
@onready var attack_area_collision: CollisionShape2D = get_node("Area2D/CollisionShape2D")

@export var move_speed = 256.0
@export var damage = 1
@export var health = 3

var can_attack = true
var can_die = false

func _physics_process(delta: float) -> void:
	if (can_attack == false or can_die == true):
		return
		
	move()
	animate()
	attack_handler()

func move() -> void:
	var direction = get_direction()
	velocity = direction * move_speed
	move_and_slide()
	
func get_direction() -> Vector2:
	return Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down"),
	).normalized()

func animate() -> void:
	if velocity.x > 0:
		texture.flip_h = false
		attack_area_collision.position.x = 58
	elif velocity.x < 0:
		texture.flip_h = true
		attack_area_collision.position.x = -58
		
	if velocity != Vector2.ZERO:
		animation.play("run")
		return
		
	animation.play("idle")
		
func attack_handler() -> void:
	if Input.is_action_pressed("attack") and can_attack:
		can_attack = false
		animation.play("attack")

func _on_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"attack":
			can_attack = true
		"death":
			get_tree().reload_current_scene()


func _on_attack_area_entered(body: Node2D) -> void:
	body.update_health(damage)
	
func update_health(value) -> void:
	health -= value
	if health <= 0:
		can_die = true
		animation.play("death")
		attack_area_collision.disabled = true
		return
		
	dmg_animation.play("hit")
