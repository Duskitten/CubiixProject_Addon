extends Node
@onready var Core = get_node("/root/Main_Scene/CoreLoader")

var GameVersion = "V_A.01.00"

signal Setting_Changed

var save_template = {
	"LastChar_Save":"",
}

var Data:Dictionary = {}

var KillThreads = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var Json = JSON.new()
	var IsFile = FileAccess.file_exists(OS.get_executable_path().get_base_dir()+"/client.json")
	print(IsFile)
	if !IsFile:
		var NewFile = FileAccess.open(OS.get_executable_path().get_base_dir()+"/client.json",FileAccess.WRITE)
		NewFile.store_string(JSON.stringify(save_template))
		NewFile.close()

	var JsonFile = FileAccess.get_file_as_string(OS.get_executable_path().get_base_dir()+"/client.json")
	Json.parse(JsonFile)
	Data = Json.data
	
	###For continuity/Updating purposes
	data_failsafe_check(save_template)

func data_failsafe_check(pathobj) -> void:
	for i in pathobj.keys():
		if pathobj[i] is Dictionary:
			for n in pathobj[i].keys():
				if !Data[i].has(n):
					Data[i][n] = pathobj[i][n]
			data_failsafe_check(pathobj[i])

func _setup_audio(data:Dictionary) -> void:
	for i in data.keys():
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(i),data[i])

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		KillThreads = true
		Core.AssetData.thread_force_post()
		#Core.Persistant_Core
		var NewFile = FileAccess.open(OS.get_executable_path().get_base_dir()+"/client.json",FileAccess.WRITE)
		NewFile.store_string(JSON.stringify(Data))
		NewFile.close()
