extends Node

var current_ch : int = 1
var max_ch : int
var channel_list : Array
var channel_name_list : Array

var is_swap_plus_and_minus : bool = false
signal swaping_plus_and_minus(state)

func _ready() -> void:
	load_data()
	# 读取上一次退出时保存的台号及换台键位是否倒转
	channel_list=load("res://channels/channels.json").data 
	channel_name_list = load("res://channels/channels_name.json").data
	max_ch = channel_list.size()
	# 读取电视台url和中文台名
	
	if(current_ch != 1):
		change_channel(current_ch)
		# 如果上一次退出不是央视1台则自动换台
	emit_signal("swaping_plus_and_minus",is_swap_plus_and_minus)
	# 更新换台键位状态
	
func _process(_delta: float) -> void:
	if(Input.is_action_just_released("CH_PLUS")):
		if(is_swap_plus_and_minus):
			change_channel_number_minus()
		else:
			change_channel_number_plus()
		# 增加频道号
		# 如果交换增减按键，则减少
		change_channel(current_ch)
		# 换台
	elif(Input.is_action_just_released("CH_MINUS")):
		if(is_swap_plus_and_minus):
			change_channel_number_plus()
		else:
			change_channel_number_minus()
		# 减少频道号
		# 如果交换增减按键，则增加
		change_channel(current_ch)
		# 换台
	if(Input.is_action_just_released("TOGGLE_FASTMODE")):
		$"../WebViewContainer/WebView".change_fastmode()
		# 切换快速模式
	if(Input.is_action_just_released("TOGGLE_SOURCE") && 
		Input.is_action_pressed("TOGGLE_FASTMODE")):
		quit_app()
		# 退出（需按住切换键的同时松开退出键）
	if(Input.is_action_just_released("TOGGLE_SWAP_PLUS_MINUS")):
		# 切换上下翻页/下上翻页
		if(is_swap_plus_and_minus):
			is_swap_plus_and_minus = false
		else:
			is_swap_plus_and_minus = true
		
		Input.start_joy_vibration(0,0.8,0.5,0.5)
		# 震动提示切换成功
		emit_signal("swaping_plus_and_minus",is_swap_plus_and_minus)
		# 发送切换信号

func change_channel_number_plus() -> void:
	# 增加频道号，只增加值，不换台
	if(current_ch>=max_ch):
		current_ch = 1
	else:
		current_ch += 1

func change_channel_number_minus() -> void:
	# 减少频道号，只减少值，不换台
	if(current_ch <= 1):
		current_ch = max_ch
	else:
		current_ch -= 1

func get_channel_url(ch_num : int):
	return channel_list.get(ch_num-1)
	# 根据台号获取电视台URL

func get_channel_name(ch_num : int):
	return channel_name_list.get(ch_num-1)
	# 根据台号获取电视台中文名称

# 换台操作
func change_channel(ch_num : int) -> void:
	var delay_timer = $"../WebViewContainer/ChangeChannelTimer"
	# 与ChangeChannelTimer联动
	# 当快速切换电视台的时候增加一个1秒的切换延迟，以避免短时间内给浏览器发送过多请求
	if(delay_timer.is_stopped()==false):
		delay_timer.stop()
		# 快速切换时停止ChangeChannelTimer执行，因为当ChangeChannelTimer执行时将进行换台
		
	$"../HintTextContainer/ChLabel".text = String.num_int64(ch_num)
	$"../HintTextContainer/NameLabel".text = get_channel_name(ch_num)
	# 换台时切换台号及中文名称
	$"../WebViewContainer/WebView".set_visible(false)
	# 将WebView隐藏掉
	delay_timer.start(0.5)
	# 启动换台定时器 0.5s后换台
	#$"../WebViewContainer/WebView".load_url(get_channel_url(ch_num))


func _on_change_channel_timer_timeout() -> void:
	$"../WebViewContainer/WebView".load_url(get_channel_url(current_ch))
	# 当换台定时器发送时间到信号的时候进行换台

func save_data() -> void:
	# 保存当前正在看的频道和上下键状态
	var cfg = ConfigFile.new()
	
	cfg.set_value("System","is_swap_plus_and_minus",is_swap_plus_and_minus)
	cfg.set_value("User","last_channel",current_ch)
	
	cfg.save("user://gdtv.cfg")
	
func load_data() -> void:
	# 读取上次正在看的频道和上下键状态，如果没有文件则自动CCAV-1&不交换上下键
	var cfg = ConfigFile.new()
	var err = cfg.load("user://gdtv.cfg")
	
	if(err != OK):
		current_ch = 1
		is_swap_plus_and_minus = false
	else:
		current_ch = cfg.get_value("User","last_channel",1)
		is_swap_plus_and_minus = cfg.get_value("System","is_swap_plus_and_minus",false)

	
func quit_app() -> void:
	# 退出前保存正在看的频道号和上下键状态
	save_data()
	get_tree().quit()


func _on_web_view_fast_mode_changed(current_mode: Variant) -> void:
	if(current_mode == true):
		Input.start_joy_vibration(0,0.5,0.2,0.2)
		# 高速模式：短震动
	else:
		Input.start_joy_vibration(0,0.5,0.2,1)
		# 兼容模式：长震动
