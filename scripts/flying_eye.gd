extends CharacterBody2D

@onready var player = %Player;

const MOVE_SPEED = 50.0;
const MAX_HEALTH = 50;

var health = MAX_HEALTH;

func _physics_process(_delta: float) -> void:
	if player == null:
		print("No player found");
		return ;

	var direction_to_player = global_position.direction_to(player.global_position);

	if global_position.distance_to(player.global_position) < 100:
		velocity = Vector2.ZERO;
		return ;

	velocity = direction_to_player * MOVE_SPEED;
	move_and_slide();


func take_damage() -> void:
	$AnimatedSprite2D.play("hit");
	health -= 10;
	if health <= 0:
		await $AnimatedSprite2D.animation_finished;
		$AnimatedSprite2D.play("death");
		queue_free();
		return ;
	await $AnimatedSprite2D.animation_finished;
	$AnimatedSprite2D.play("fly");