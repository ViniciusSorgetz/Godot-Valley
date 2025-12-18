extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func flash():
    animation_player.play("flash_animation")