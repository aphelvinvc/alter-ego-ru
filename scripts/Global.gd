extends Node

func to_two_digits(n):
	if n < 10:
		return "0"+str(n)
	return str(n)

func to_m_digits(n,m=2):
	var s = str(n)
	var l = s.length()
	for i in range(m-l):
		s = "0" + s
	return s

func get_main():
	return get_node("/root/Main")

func change_face(num):
	get_main().change_face(num)

const TIMEZONES = [
	{
		"id": "auto",
		"name_ru": "Авто (Системное время)",
		"name_ua": "Авто (Системний час)",
		"name_en": "Auto (System Time)",
		"name_jp": "自動（システム時間）",
		"offset": null
	},
	{
		"id": "ua_iev",
		"name_ru": "Украина: Киев (UTC+2)",
		"name_ua": "Україна: Київ (UTC+2)",
		"name_en": "Ukraine: Kyiv (UTC+2)",
		"name_jp": "ウクライナ：キーウ (UTC+2)",
		"offset": 2
	},
	{
		"id": "ru_kln",
		"name_ru": "Россия: Калининград (UTC+2)",
		"name_ua": "Росія: Калінінград (UTC+2)",
		"name_en": "Russia: Kaliningrad (UTC+2)",
		"name_jp": "ロシア：カリーニングラード (UTC+2)",
		"offset": 2
	},
	{
		"id": "ru_msk",
		"name_ru": "Россия: Москва / СПб (UTC+3)",
		"name_ua": "Росія: Москва / СПб (UTC+3)",
		"name_en": "Russia: Moscow (UTC+3)",
		"name_jp": "ロシア：モスクワ (UTC+3)",
		"offset": 3
	},
	{
		"id": "by_msq",
		"name_ru": "Беларусь: Минск (UTC+3)",
		"name_ua": "Білорусь: Мінськ (UTC+3)",
		"name_en": "Belarus: Minsk (UTC+3)",
		"name_jp": "ベラルーシ：ミンスク (UTC+3)",
		"offset": 3
	},
	{
		"id": "ru_sam",
		"name_ru": "Россия: Самара (UTC+4)",
		"name_ua": "Росія: Самара (UTC+4)",
		"name_en": "Russia: Samara (UTC+4)",
		"name_jp": "ロシア：サマーラ (UTC+4)",
		"offset": 4
	},
	{
		"id": "am_evn",
		"name_ru": "Армения: Ереван (UTC+4)",
		"name_ua": "Вірменія: Єреван (UTC+4)",
		"name_en": "Armenia: Yerevan (UTC+4)",
		"name_jp": "アルメニア：エレバン (UTC+4)",
		"offset": 4
	},
	{
		"id": "az_bak",
		"name_ru": "Азербайджан: Баку (UTC+4)",
		"name_ua": "Азербайджан: Баку (UTC+4)",
		"name_en": "Azerbaijan: Baku (UTC+4)",
		"name_jp": "アゼルバイジャン：バクー (UTC+4)",
		"offset": 4
	},
	{
		"id": "ge_tbi",
		"name_ru": "Грузия: Тбилиси (UTC+4)",
		"name_ua": "Грузія: Тбілісі (UTC+4)",
		"name_en": "Georgia: Tbilisi (UTC+4)",
		"name_jp": "ジョージア：トビリシ (UTC+4)",
		"offset": 4
	},
	{
		"id": "ru_svx",
		"name_ru": "Россия: Екатеринбург (UTC+5)",
		"name_ua": "Росія: Єкатеринбург (UTC+5)",
		"name_en": "Russia: Yekaterinburg (UTC+5)",
		"name_jp": "ロシア：エカテリンブルク (UTC+5)",
		"offset": 5
	},
	{
		"id": "kz_all",
		"name_ru": "Казахстан: Астана / Алматы (UTC+5)",
		"name_ua": "Казахстан: Астана / Алмати (UTC+5)",
		"name_en": "Kazakhstan: Astana / Almaty (UTC+5)",
		"name_jp": "カザフスタン：アスタナ (UTC+5)",
		"offset": 5
	},
	{
		"id": "uz_tas",
		"name_ru": "Узбекистан: Ташкент (UTC+5)",
		"name_ua": "Узбекистан: Ташкент (UTC+5)",
		"name_en": "Uzbekistan: Tashkent (UTC+5)",
		"name_jp": "ウズベキスタン：タシケント (UTC+5)",
		"offset": 5
	},
	{
		"id": "tj_dyu",
		"name_ru": "Таджикистан: Душанбе (UTC+5)",
		"name_ua": "Таджикистан: Душанбе (UTC+5)",
		"name_en": "Tajikistan: Dushanbe (UTC+5)",
		"name_jp": "タジキスタン：ドゥシャンベ (UTC+5)",
		"offset": 5
	},
	{
		"id": "tm_asb",
		"name_ru": "Туркменистан: Ашхабад (UTC+5)",
		"name_ua": "Туркменістан: Ашгабат (UTC+5)",
		"name_en": "Turkmenistan: Ashgabat (UTC+5)",
		"name_jp": "トルクメニスタン：アシガバート (UTC+5)",
		"offset": 5
	},
	{
		"id": "ru_oms",
		"name_ru": "Россия: Омск (UTC+6)",
		"name_ua": "Росія: Омськ (UTC+6)",
		"name_en": "Russia: Omsk (UTC+6)",
		"name_jp": "ロシア：オムスク (UTC+6)",
		"offset": 6
	},
	{
		"id": "kg_fru",
		"name_ru": "Кыргызстан: Бишкек (UTC+6)",
		"name_ua": "Киргизстан: Бішкек (UTC+6)",
		"name_en": "Kyrgyzstan: Bishkek (UTC+6)",
		"name_jp": "キルギス：ビシュケク (UTC+6)",
		"offset": 6
	},
	{
		"id": "ru_ovb",
		"name_ru": "Россия: Новосибирск / Красноярск (UTC+7)",
		"name_ua": "Росія: Новосибірськ / Красноярськ (UTC+7)",
		"name_en": "Russia: Novosibirsk (UTC+7)",
		"name_jp": "ロシア：ノボシビルスク (UTC+7)",
		"offset": 7
	},
	{
		"id": "ru_ikt",
		"name_ru": "Россия: Иркутск (UTC+8)",
		"name_ua": "Росія: Іркутськ (UTC+8)",
		"name_en": "Russia: Irkutsk (UTC+8)",
		"name_jp": "ロシア：イルクーツク (UTC+8)",
		"offset": 8
	},
	{
		"id": "ru_yks",
		"name_ru": "Россия: Якутск (UTC+9)",
		"name_ua": "Росія: Якутськ (UTC+9)",
		"name_en": "Russia: Yakutsk (UTC+9)",
		"name_jp": "ロシア：ヤクーツク (UTC+9)",
		"offset": 9
	},
	{
		"id": "ru_vvo",
		"name_ru": "Россия: Владивосток (UTC+10)",
		"name_ua": "Росія: Владивосток (UTC+10)",
		"name_en": "Russia: Vladivostok (UTC+10)",
		"name_jp": "ロシア：ウラジオストク (UTC+10)",
		"offset": 10
	},
	{
		"id": "ru_gdn",
		"name_ru": "Россия: Магадан / Сахалин (UTC+11)",
		"name_ua": "Росія: Магадан / Сахалін (UTC+11)",
		"name_en": "Russia: Magadan / Sakhalin (UTC+11)",
		"name_jp": "ロシア：マガダン (UTC+11)",
		"offset": 11
	},
	{
		"id": "ru_pkc",
		"name_ru": "Россия: Камчатка (UTC+12)",
		"name_ua": "Росія: Камчатка (UTC+12)",
		"name_en": "Russia: Kamchatka (UTC+12)",
		"name_jp": "ロシア：カムチャッカ (UTC+12)",
		"offset": 12
	},
	{
		"id": "md_kiv",
		"name_ru": "Молдова: Кишинёв (UTC+2)",
		"name_ua": "Молдова: Кишинів (UTC+2)",
		"name_en": "Moldova: Chisinau (UTC+2)",
		"name_jp": "モルドバ：キシナウ (UTC+2)",
		"offset": 2
	}
]

var current_tz_index: int = 0

func _ready():
	load_timezone()
	setup_font_fallbacks()

func setup_font_fallbacks():
	var main_font = load("res://NotoSansJP-Regular.ttf")
	if main_font and ResourceLoader.exists("res://ukr_fallback.ttf"):
		var fallback_font = load("res://ukr_fallback.ttf")
		if fallback_font:
			main_font.fallbacks = [fallback_font]

func get_current_datetime() -> Dictionary:
	if current_tz_index < 0 or current_tz_index >= TIMEZONES.size():
		current_tz_index = 0
	var tz = TIMEZONES[current_tz_index]
	if tz["offset"] == null:
		return Time.get_datetime_dict_from_system()
	var unix_ts = int(Time.get_unix_time_from_system()) + int(tz["offset"] * 3600)
	return Time.get_datetime_dict_from_unix_time(unix_ts)

func get_timezone_name() -> String:
	if current_tz_index < 0 or current_tz_index >= TIMEZONES.size():
		current_tz_index = 0
	var tz = TIMEZONES[current_tz_index]
	var lang = "ru"
	if ScriptHelper and "lang" in ScriptHelper and ScriptHelper.lang != null:
		lang = ScriptHelper.lang
	if lang == "ua" and "name_ua" in tz:
		return tz["name_ua"]
	elif lang == "ru":
		return tz["name_ru"]
	elif lang == "jp":
		return tz["name_jp"]
	return tz["name_en"]

func set_timezone_index(idx: int):
	current_tz_index = posmod(idx, TIMEZONES.size())
	save_timezone()

func next_timezone():
	set_timezone_index(current_tz_index + 1)

func prev_timezone():
	set_timezone_index(current_tz_index - 1)

func load_timezone():
	if not FileAccess.file_exists("user://timezone.save"):
		current_tz_index = 0
		return
	var f = FileAccess.open("user://timezone.save", FileAccess.READ)
	if f:
		var txt = f.get_as_text().strip_edges()
		current_tz_index = clampi(int(txt), 0, TIMEZONES.size() - 1)

func save_timezone():
	var f = FileAccess.open("user://timezone.save", FileAccess.WRITE)
	if f:
		f.store_string(str(current_tz_index))

func vibrate(duration_ms: int = 25):
	if OS.has_feature("mobile") or OS.has_feature("android") or OS.has_feature("ios"):
		Input.vibrate_handheld(duration_ms)

func toggle_fullscreen():
	var mode = DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
