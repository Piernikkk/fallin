extends CharacterBody2D

@onready var player = get_node("/root/Level0/Player");
@onready var projectile = preload("res://sprites/eye_projectile.tscn");
@onready var shoot_timer = $Timer;

const MOVE_SPEED = 50.0;
const MAX_HEALTH = 30;
const FALL_SPEED_MULTIPLIER = 0.05;

var health = MAX_HEALTH;

func _ready() -> void:
	shoot_timer.start();

func _physics_process(delta: float) -> void:
	if dying and not is_on_floor():
		velocity += get_gravity() * delta;
		move_and_slide();
		return ;

	if player == null:
		print("No player found");
		return ;

	# Fall down until we reach the player's Y level
	if global_position.y < player.global_position.y:
		velocity += get_gravity() * delta * FALL_SPEED_MULTIPLIER;
		velocity.x = 0;
	else:
		velocity.y = 0;
		
		var direction_x = sign(player.global_position.x - global_position.x);
		
		if global_position.distance_to(player.global_position) < 60:
			velocity.x = 0;
		else:
			velocity.x = direction_x * MOVE_SPEED;
	
	move_and_slide();

var dying = false

func take_damage() -> void:
	if dying:
		shoot_timer.set_paused(true);
		return ;
	$AnimatedSprite2D.play("hit");
	health -= 10;
	if health <= 0:
		await $AnimatedSprite2D.animation_finished;
		dying = true;
		$AnimatedSprite2D.play("death");
		await $AnimatedSprite2D.animation_finished;
		Globals.increment_enemies_killed();
		queue_free();
		return ;
	await $AnimatedSprite2D.animation_finished;
	$AnimatedSprite2D.play("fly");
	shoot_timer.set_paused(false);

func shoot() -> void:
	if dying:
		return ;
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
