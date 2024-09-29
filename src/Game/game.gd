extends Node2D

@onready var car = $Car
@onready var bullet_manger = $BulletManger
@onready var manmy = $Manmy
@onready var game = $"."
@onready var mirage = $Mirage
@onready var color_rect = $Mirage/CanvasLayer/ColorRect
@onready var powerup_timer = $powerup_timer
@onready var bgmusic = $bgmusic
@onready var laugh = $laugh
@onready var cling = $cling

var can_laugh = false

@export var level2 : PackedScene
@export var blood : PackedScene

func _ready() -> void:
	randomize()
	color_rect.visible = false
	Signalmanager.fired_bullet.connect(Callable(bullet_manger, "handle_bullet_spawned"))
	Signalmanager.laugh_powerup.connect(Callable(game, "laugh_powerup"))
	Signalmanager.laugh_powerup.connect(Callable(car, "laugh_powerup"))
	Signalmanager.size_powerup.connect(Callable(car, "size_powerup"))
	Signalmanager.druken_powerup.connect(Callable(game, "druken_powerup"))
	Signalmanager.triple_powerup.connect(Callable(car, "triple_powerup"))
	Signalmanager.sheild_powerup.connect(Callable(car, "sheild_powerup"))
	Signalmanager.medic_powerup.connect(Callable(car, "medic_powerup"))
	
	Signalmanager.powerup_reset.connect(Callable(car, "powerup_reset"))
	
func _physics_process(_delta):
	if !bgmusic.playing and can_laugh == false:
		bgmusic.play()
	mirage.global_position = car.global_position

func laugh_powerup():
	can_laugh = true
	laugh.play()
	cling.play()	
	bgmusic.volume_db = -10

func druken_powerup():
	powerup_timer.start()
	cling.play()
	color_rect.visible = true
	

func _on_powerup_timer_timeout():
	if color_rect.visible == true:
		color_rect.visible = false


func _on_laugh_finished():
	bgmusic.volume_db = 0
	can_laugh = false


	

func _on_finish_line_body_entered(body):
	if body.is_in_group("car"):
		get_tree().change_scene_to_packed(level2)
