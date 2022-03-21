extends Node


var _sfx_lookup := []


func _ready() -> void:
    yield(GameManager, "initialized")
    print("Caching SFX lookup...")

    var file := File.new()
    var err := file.open(GameManager.game_path + "/audio/sfx.SDT", File.READ)
    if err != OK:
        push_error("Failed to open SFX lookup file")

    # Each entry are 20 bytes long on PC.
    for i in file.get_len() / 20:
        var meta := SFXMeta.new()
        meta.offset = file.get_32()
        meta.size = file.get_32()
        meta.sample_rate = file.get_32()
        meta.loop_start = file.get_32()
        meta.loop_end = file.get_32()
        _sfx_lookup.append(meta)
    print("Cached %d SFX entries" % _sfx_lookup.size())


class SFXMeta:
    var offset: int
    var size: int
    var sample_rate: int
    var loop_start: int
    var loop_end: int
