extends Node


var _sfx_lookup := []


func _ready() -> void:
	yield(GameManager, "initialized")
	print("Caching SFX lookup...")

	_sfx_lookup = GTAAssetLoader.load_sfx_lookup(GameManager.game_path + "/audio/sfx.SDT")

	print("Cached %d SFX entries" % _sfx_lookup.size())


func load_sfx(id: int) -> AudioStreamSample:
	print("Loading SFX %d" % id)
	return GTAAssetLoader.load_sfx(GameManager.game_path + "/audio/sfx.RAW", _sfx_lookup[id])
