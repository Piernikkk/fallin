extends CharacterBody2D

@onready var player = %Player;
@onready var projectile = preload("res://sprites/eye_projectile.tscn");

const MOVE_SPEED = 50.0;
const MAX_HEALTH = 50;

var health = MAX_HEALTH;

func _physics_process(delta: float) -> void:
	if dying and not is_on_floor():
		velocity += get_gravity() * delta;

	if player == null:
		print("No player found");
		return ;

	var direction_to_player = global_position.direction_to(player.global_position);

	if global_position.distance_to(player.global_position) < 60:
		velocity = Vector2.ZERO;
		return ;

	velocity = direction_to_player * MOVE_SPEED;
	move_and_slide();

var dying = false

func take_damage() -> void:
	if dying:
		return ;
	$AnimatedSprite2D.play("hit");
	health -= 10;
	if health <= 0:
		await $AnimatedSprite2D.animation_finished;
		dying = true;
		$AnimatedSprite2D.play("death");
		await $AnimatedSprite2D.animation_finished;
		queue_free();
		return ;
	await $AnimatedSprite2D.animation_finished;
	$AnimatedSprite2D.play("fly");

func shoot() -> void:
	$AnimatedSprite2D.play("shoot");
	var projectile_instance = projectile.instantiate();
	projectile_instance.global_position = global_position;
	projectile_instance.rotation = global_position.angle_to_point(player.global_position);
	get_parent().add_child(projectile_instance);
	

func _on_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "shoot":
		$AnimatedSprite2D.play("fly");


func _on_timer_timeout() -> void:
	shoot();
