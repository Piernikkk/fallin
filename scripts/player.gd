extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -250.0
const RUN_SPEED = 200.0

func _ready() -> void:
	$AnimatedSprite2D.play("idle");


func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta;

		
	var run = Input.is_action_pressed("run");
	var current_speed = RUN_SPEED if run else SPEED;

	# jump
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY;

	# movement 
	var direction := Input.get_axis("left", "right");
	if direction:
		velocity.x = direction * current_speed;
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed);
	play_walk_animation(direction, run);
	move_and_slide();

func play_walk_animation(direction: float, run: bool) -> void:
	var animationSprite = $AnimatedSprite2D;

	const walk_right_anim = "walk_right";
	const walk_left_anim = "walk_left";
	const run_right_anim = "run_right";
	const run_left_anim = "run_left";

	var animation_left = run_left_anim if run else walk_left_anim;
	var animation_right = run_right_anim if run else walk_right_anim;

	if direction > 0.5:
		animationSprite.play(animation_right);
	elif direction < -0.5:
		animationSprite.play(animation_left);
	else:
		animationSprite.play("idle");
