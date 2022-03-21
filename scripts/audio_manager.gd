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
		meta.loop_start = (file.get_32() + (1 << 31)) % (1 << 32) - (1 << 31)
		meta.loop_end = (file.get_32() + (1 << 31)) % (1 << 32) - (1 << 31)
		_sfx_lookup.append(meta)

	print("Cached %d SFX entries" % _sfx_lookup.size())


func load_sfx(id: int) -> AudioStreamSample:
	print("Loading SFX %d" % id)
	var file := File.new()
	
	var err := file.open(GameManager.game_path + "/audio/sfx.RAW", File.READ)
	if err != OK:
		push_error("Failed to open SFX file")

	var meta := _sfx_lookup[id] as SFXMeta
	var stream := AudioStreamSample.new()

	file.seek(meta.offset)
	stream.data = file.get_buffer(meta.size)
	file.close()

	stream.format = AudioStreamSample.FORMAT_16_BITS
	stream.loop_begin = meta.loop_start / 2
	stream.loop_end = (
		meta.size if meta.loop_end == -1
		else meta.loop_end
	) / 2
	stream.loop_mode = (
		AudioStreamSample.LOOP_DISABLED if meta.loop_end < 1
		else AudioStreamSample.LOOP_FORWARD
	)
	stream.mix_rate = meta.sample_rate

	return stream


class SFXMeta:
	var offset: int
	var size: int
	var sample_rate: int
	var loop_start: int
	var loop_end: int
