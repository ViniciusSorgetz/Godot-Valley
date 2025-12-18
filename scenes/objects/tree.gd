extends StaticBody2D

@onready var flash_sprite_2d: = $FlashSprite2d

func hit(tool: Enum.Tool):
    flash_sprite_2d.flash()
    print(tool);