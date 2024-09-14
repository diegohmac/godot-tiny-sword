extends Area2D

@export var damage: int = 1

func _on_body_entered(body: Node2D) -> void:
	body.update_health(damage)


func _on_timer_timeout() -> void:
	queue_free()
