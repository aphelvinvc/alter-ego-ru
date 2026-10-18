extends Node2D

func to_two_digits(n):
	if n < 10:
		return "0"+str(n)
	return str(n)

var current_scene
var loading_inst
const menu_btns = preload("res://scenes/menu_btns.tscn")
const loading = preload("res://scenes/loading.tscn")
const scenes = {
	"clock_scene":preload("res://scenes/clock_scene.tscn"),
	"calendar_scene":preload("res://scenes/calendar.tscn"),
	"freetime":preload("res://scenes/freetalk.tscn"),
	"help":preload("res://scenes/help.tscn"),
	"diagnose":preload("res://scenes/diagnose.tscn"),
	"worlden":preload("res://scenes/world_en.tscn"),
	"charen":preload("res://scenes/char_en.tscn")
}

func load_scene(scene_name,skip_loading=false):
	current_scene.queue_free()
	if skip_loading:
		current_scene = scenes[scene_name].instantiate()
		add_child(current_scene)
		return
	loading_inst = loading.instantiate()
	add_child(loading_inst)
	current_scene = scenes[scene_name].instantiate()
	
func stop_loading():
	loading_inst.queue_free()
	add_child(current_scene)

var rng = RandomNumberGenerator.new()
var blink_timer: float = 0.0
var next_blink_interval: float = 4.0
var is_blinking: bool = false
var is_reacting: bool = false
const reaction_faces = [2, 3, 13, 22]

func _ready():
	rng.randomize()
	next_blink_interval = rng.randf_range(3.0, 6.0)
	current_scene = $Greeting
	Sound.init()
	ScriptHelper.init()
	$Greeting.load_mess()

func _process(delta):
	if current_scene and current_scene.name == "MenuBtns" and not is_reacting:
		blink_timer += delta
		if not is_blinking and blink_timer >= next_blink_interval:
			is_blinking = true
			change_face(2)
			var t = create_tween()
			t.tween_interval(0.14)
			t.finished.connect(func():
				if current_scene and current_scene.name == "MenuBtns" and not is_reacting:
					change_face(0)
				is_blinking = false
				blink_timer = 0.0
				next_blink_interval = rng.randf_range(3.0, 6.0)
			)

func poke_reaction():
	if is_reacting or current_scene == null or current_scene.name != "MenuBtns":
		return
	is_reacting = true
	is_blinking = false
	var chosen_face = reaction_faces[rng.randi_range(0, reaction_faces.size() - 1)]
	change_face(chosen_face)
	Sound.play_se(1)
	Global.vibrate(30)
	var t = create_tween()
	t.tween_interval(1.2)
	t.finished.connect(func():
		if current_scene and current_scene.name == "MenuBtns":
			change_face(0)
		is_reacting = false
		blink_timer = 0.0
	)
	
func change_face(num):
	var fname = "AlterEgoFace"+to_two_digits(num)+".png"
	get_node("AEFace").texture = load("res://face/"+fname)
	
func exit_current_scene(skip_loading=false):
	is_reacting = false
	is_blinking = false
	blink_timer = 0.0
	change_face(0)
	if Sound.current_song != 10:
		Sound.play_bgm(10)
	current_scene.queue_free()
	current_scene = menu_btns.instantiate()
	if skip_loading:
		add_child(current_scene)
		return
	Sound.play_se(4)
	loading_inst = loading.instantiate()
	add_child(loading_inst)
	#add_child(current_scene)


func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F11 or (event.keycode == KEY_ENTER and event.alt_pressed):
			Global.toggle_fullscreen()
			get_viewport().set_input_as_handled()
			return
		elif event.keycode == KEY_M:
			var master_bus = AudioServer.get_bus_index("Master")
			var is_muted = AudioServer.is_bus_mute(master_bus)
			AudioServer.set_bus_mute(master_bus, not is_muted)
			get_viewport().set_input_as_handled()
			return
		elif event.keycode == KEY_ESCAPE:
			handle_back()
			get_viewport().set_input_as_handled()
			return
	
	if event.is_action_pressed("ui_cancel"):
		handle_back()
		get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if current_scene and current_scene.name == "MenuBtns":
			var mpos = get_local_mouse_position()
			if mpos.x >= -120 and mpos.x <= 120 and mpos.y >= -100 and mpos.y <= 100:
				poke_reaction()
				get_viewport().set_input_as_handled()
				return


func handle_back():
	if current_scene == null:
		return
	var scene_name = current_scene.name
	if scene_name == "MenuBtns":
		get_tree().quit()
		return
	if scene_name == "Greeting":
		exit_current_scene(true)
		return
	if scene_name == "ClockScene":
		if current_scene.has_method("_on_exit_released"):
			current_scene._on_exit_released()
		else:
			exit_current_scene()
		return
	if scene_name == "Calendar":
		if current_scene.has_method("exit"):
			current_scene.exit()
		else:
			exit_current_scene()
		return
	if scene_name == "CharEn":
		if current_scene.get("selected_char") != null:
			current_scene.finished_item()
		else:
			exit_current_scene()
		return
	if scene_name == "WorldEn":
		if current_scene.get("an_item_selected"):
			current_scene.finished_item()
		else:
			exit_current_scene()
		return
	if scene_name in ["Freetalk", "Help", "Diagnose"]:
		exit_current_scene()
		return
	exit_current_scene()

