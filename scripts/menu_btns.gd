extends Node2D

#var move_shrink_v = Vector2(24,24)
var move_shrink_v = Vector2(32,32)
func _ready():
	$language.texture_normal = load("res://misc/%s.png" % ScriptHelper.lang)
	var tween = create_tween()
	var tween_time=0.1
	tween.set_parallel()
	for child in get_children():
		child.scale = Vector2(0,0)
		var move_scale = 1 if child.name != "language" else 0.5
		child.position = child.position + move_shrink_v * move_scale
		tween.tween_property(child,"scale",Vector2(1,1),tween_time)
		tween.tween_property(child,"position",child.position-move_shrink_v*move_scale,tween_time)

func btn(scene_name,skip_loading=false):
	Sound.play_se(1)
	var tween = create_tween()
	var tween_time=0.1
	tween.set_parallel(true)
	match scene_name:
		"worlden":
			Sound.play_bgm(17)
		"charen":
			Sound.play_bgm(3)
		"diagnose":
			Sound.play_bgm(18)
	tween.finished.connect(get_node("/root/Main").load_scene.bind(scene_name,skip_loading))
	for child in get_children():
		var move_scale = 1 if child.name != "language" else 0.5	
		tween.tween_property(child,"scale",Vector2.ZERO,tween_time)
		tween.tween_property(child,"position",child.position+move_shrink_v*move_scale,tween_time)
	#get_parent().load_scene(scene_name)

func freetalk_btn():
	btn("freetime",true)
	
func calendar_btn():
	btn("calendar_scene")
	
func clock_btn():
	btn("clock_scene")
	
func save_language():
	var f = FileAccess.open("user://lang.save",FileAccess.WRITE)
	f.store_string(ScriptHelper.lang)
	
func change_language():
	var next_lang = "ru"
	if ScriptHelper.lang == "ru":
		next_lang = "ua"
	elif ScriptHelper.lang == "ua":
		next_lang = "en"
	elif ScriptHelper.lang == "en":
		next_lang = "jp"
	else:
		next_lang = "ru"
	ScriptHelper.get_script_obj(next_lang)
	$language.texture_normal = load("res://misc/%s.png" % next_lang)
	save_language()

var is_navigating = false
func _unhandled_input(event):
	if is_navigating:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1, KEY_C:
				is_navigating = true
				calendar_btn()
				get_viewport().set_input_as_handled()
			KEY_2, KEY_T:
				is_navigating = true
				clock_btn()
				get_viewport().set_input_as_handled()
			KEY_3, KEY_F:
				is_navigating = true
				freetalk_btn()
				get_viewport().set_input_as_handled()
			KEY_4, KEY_P:
				is_navigating = true
				btn("charen", false)
				get_viewport().set_input_as_handled()
			KEY_5, KEY_W:
				is_navigating = true
				btn("worlden", false)
				get_viewport().set_input_as_handled()
			KEY_6, KEY_D:
				is_navigating = true
				btn("diagnose", false)
				get_viewport().set_input_as_handled()
			KEY_H:
				is_navigating = true
				btn("help", false)
				get_viewport().set_input_as_handled()
			KEY_L:
				change_language()
				get_viewport().set_input_as_handled()

