extends WebView

var is_fast_mode = false
signal fast_mode_changed(current_mode)

func _on_page_load_finished(_msg: String) -> void:
	# print("加载完成"+msg);
	if(is_fast_mode):
		$"../FullScreenTimer".start(1.5)
	else:
		$"../FullScreenTimer".start(4)
	# 快速模式在1.5s后执行全屏指令，兼容模式下4s
	# 由于WebView在ajax加载尚未完全完成的时候就会触发PageLoadFinished信号，因此需要增加一个定时器以延迟全屏
	# $".".eval('document.querySelector(".full2").click()') 


func _on_full_screen_timer_timeout() -> void:
	$".".eval('document.querySelector(".full2").click();document.querySelector("video").volume=1')
	$".".set_visible(true)
	# 全屏并最大化音量，目前快速模式最大化音量有bug，以后再修
	#$".".eval('document.querySelector("video").volume=1')

func change_fastmode() -> void:
	if(is_fast_mode):
		is_fast_mode=false
	else:
		is_fast_mode=true
		
	emit_signal("fast_mode_changed",is_fast_mode)
