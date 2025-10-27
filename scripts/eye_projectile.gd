extends Area2D

var traveled_distance = 0;

const SPEED = 150.0;
const MAX_DISTANCE = 2000;

var speed = SPEED;
var exploded = false;

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation);
	position += direction * speed * delta;
	traveled_distance += speed * delta;
	if traveled_distance >= MAX_DISTANCE:
		queue_free();
		return ;

func _on_body_entered(body: Node) -> void:
	if exploded:
		return ;
	print("Projectile hit: %s" % body.name);
	speed = 0;
	$AnimatedSprite2D.play("boom");
	if body is CharacterBody2D:
		if body.has_method("take_damage"):
			exploded = true;
			body.take_damage(10);
	
	await $AnimatedSprite2D.animation_finished;
	queue_free();