extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $Animation/AnimationPlayer
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("Player");
@onready var flash_sprite_animated_2d: Node = $FlashSpriteAnimated2D;
@onready var animation_tree: AnimationTree = $Animation/AnimationTree
@onready var attack_and_death_state_machine: Variant = animation_tree.get("parameters/AttackAndDeathStateMachine/playback");

var speed := 30;
var direction: Vector2;
var can_move := true;
var health := 3:
	set(value):
		health = value;
		if(health <= 0):
			attack_and_death_state_machine.travel("Death");
			animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);

func _physics_process(_delta: float) -> void:
	if(can_move):
		move();
		animate();

func hit(tool: Enum.Tool):
	if(tool == Enum.Tool.SWORD):
		flash_sprite_animated_2d.flash();
		health -= 1;

func move():
	flash_sprite_animated_2d.play(flash_sprite_animated_2d.animation);
	direction = position.direction_to(player.position);
	velocity = direction * speed;

	if(position.distance_to(player.position) > 15):
		move_and_slide();
	else:
		can_move = false;
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);

func animate():

	var dir := direction.round();

	animation_tree.set("parameters/WalkStateMachine/Walk/blend_position", dir);
	animation_tree.set("parameters/AttackAndDeathStateMachine/Death/blend_position", dir);
	animation_tree.set("parameters/AttackAndDeathStateMachine/Attack/blend_position", dir);


func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	can_move = true;
