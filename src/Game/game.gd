extends Node2D

@onready var car = $Car
@onready var bullet_manger = $BulletManger

func _ready() -> void:
	car.fired_bullet.connect(Callable(bullet_manger, "handle_bullet_spawned"))
	
