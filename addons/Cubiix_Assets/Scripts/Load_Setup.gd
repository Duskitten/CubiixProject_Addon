extends Node
var version = "V_A.01.00"

signal core_loaded

var SceneData
var AssetData
var Globals

### This is the main cubiix core loader, this has everything you need to use the Cubiix itself.
### Make sure this is set under a root node called "Main_Scene" in order to load it properly.

func _ready():
	print(version)
	Update_LogoText("Booting MindVirus Engine...")
	await get_tree().create_timer(1).timeout
	Update_LogoText("Finding Client...")
	await get_tree().create_timer(1).timeout
	Update_LogoText("Initiating Asset Load...")
	await get_tree().create_timer(1).timeout
	AssetData = load("res://addons/Cubiix_Assets/Scripts/Asset_Manager.gd").new()
	AssetData.runsetup()
	Update_LogoText("Loading Asset Data...")
	AssetData.name = "AssetData"
	await AssetData.FinishedLoad
	SceneData = load("res://addons/Cubiix_Assets/Scripts/Scene_Loader.gd").new()
	Globals = load("res://addons/Cubiix_Assets/Scripts/Globals.gd").new()
	add_child(AssetData)
	add_child(SceneData)
	add_child(Globals)
	
	Update_LogoText("Load O.K. ...")
	await get_tree().create_timer(1).timeout
	Update_LogoText("Good Luck Have Fun! :3")
	await get_tree().create_timer(1).timeout
	get_node("CanvasLayer/Loading").hide()
	print("Haoi")
		
func Update_LogoText(text:String) -> void:
	get_node("CanvasLayer/Loading/TextureRect/Label").text = text
