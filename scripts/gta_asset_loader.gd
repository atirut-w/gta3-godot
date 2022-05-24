class_name GTAAssetLoader
extends Reference
# Utility class for loading assets from GTA Trilogy(PC only)


static func load_sfx_lookup(path: String) -> Array:
    var file := File.new()
    var err := file.open(path, File.READ)
    assert(err == OK)

    var lookup := []

    for index in file.get_len() / 20:
        var meta := SFXMeta.new()
        meta.offset = file.get_32()
        meta.size = file.get_32()
        meta.samplerate = file.get_32()
        meta.loop_start = (file.get_32() + (1 << 31)) % (1 << 32) - (1 << 31)
        meta.loop_end = (file.get_32() + (1 << 31)) % (1 << 32) - (1 << 31)
        lookup.append(meta)

    return lookup


static func load_sfx(path: String, meta: SFXMeta) -> AudioStreamSample:
    var file := File.new()
    var err := file.open(path, File.READ)
    assert(err == OK)

    var stream := AudioStreamSample.new()
    stream.format = AudioStreamSample.FORMAT_16_BITS
    stream.loop_mode = (
        AudioStreamSample.LOOP_FORWARD if meta.loop_end > 0
        else AudioStreamSample.LOOP_DISABLED
    )
    stream.loop_begin = meta.loop_start / 2
    stream.loop_end = meta.loop_end / 2
    stream.mix_rate = meta.samplerate

    file.seek(meta.offset)
    stream.data = file.get_buffer(meta.size)
    file.close()

    return stream


class SFXMeta extends Reference:
    var offset: int
    var size: int
    var samplerate: int
    var loop_start: int
    var loop_end: int
