extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("Player");
@onready var flash_sprite_animated_2d: AnimatedSprite2D = $FlashSpriteAnimated2D;

enum State {WALKING, ATTACKING, DYING};
const State_Animations = {
	State.WALKING: "walk",
	State.ATTACKING: "attack",
	State.DYING: "death"
}
var current_animation_state: State = State.WALKING;
var dir_string: String = State_Animations[current_animation_state];
var speed := 30;
var direction: Vector2;
var can_move := true;
var health := 3;
		
func _physics_process(_delta: float) -> void:
	if(can_move && health > 0):
		move();
		handle_animation();


func hit(tool: Enum.Tool):
	if(tool == Enum.Tool.SWORD):
		flash_sprite_animated_2d.flash();
		decrease_health();


func move() -> void:
	flash_sprite_animated_2d.play(flash_sprite_animated_2d.animation);
	direction = position.direction_to(player.position);
	velocity = direction * speed;

	if(position.distance_to(player.position) > 15):
		current_animation_state = State.WALKING;
		move_and_slide();
	else:
		can_move = false;
		current_animation_state = State.ATTACKING;

func decrease_health():
	health -= 1;
	if(health <= 0):
		current_animation_state = State.DYING;
		handle_animation();
		animation_player.play(dir_string);

func handle_animation() -> void:

	var dir = direction.round();
	dir_string = State_Animations[current_animation_state];

	# note: dir is never (0, 0)
	if(dir.x):
		if(dir.x == 1):
			dir_string += "_right";
		if(dir.x == -1):
			dir_string += "_left";
	else:
		if(dir.y == 1):
			dir_string += "_down";
		if(dir.y == -1):
			dir_string += "_up";

	flash_sprite_animated_2d.play(dir_string);

func _on_flash_sprite_animated_2d_animation_finished() -> void:
	can_move = true;
