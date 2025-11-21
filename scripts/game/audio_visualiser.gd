
extends Control

@export var audio_player: AudioStreamPlayer

var spectrum_instance : AudioEffectInstance
const NUM_BARS : float = 64  # Number of frequency bands to display
const MAX_FREQ : float = 1000  # Frequency range to analyze
var bars : Array[ColorRect] = []
@export var shuffle_freq : bool = false
@export var flip_y : bool = false

var color_gradient := Gradient.new()  # Dynamic color transitions


func _ready() -> void:
	global_position = Vector2((get_viewport_rect().size.y / 4), (get_viewport_rect().size.y))
		# Set up color gradient (Blue → Purple → Red)
	scale = Vector2(1.5, 1.5)
	color_gradient.add_point(0.0, Color(0.2, 1.0, 0.8))  # Cyan
	color_gradient.add_point(0.5, Color(0.6, 0.2, 1.0))  # Purple
	color_gradient.add_point(1.0, Color(1.0, 0.2, 0.2))  # Red
	spectrum_instance = AudioServer.get_bus_effect_instance(4, 0)  # Bus 1, Effect 0
	create_bars()

func create_bars()-> void:
	for i in range(NUM_BARS):
		var bar : ColorRect = ColorRect.new()
		bar.color = Color(0.2, 0.8, 1.0)  # Light blue color
		bar.size = Vector2(8, 50)  # Adjust bar size
		bar.position = Vector2(i*10, 0)  # Space bars apart
		add_child(bar)
		bars.append(bar)

func _physics_process(_delta: float) -> void:
	if not spectrum_instance:
		return
	var max_freq_amp : int = bars.reduce(func(m : ColorRect, b:ColorRect)->ColorRect: return b if b.size.y > m.size.y else m).size.y 
	
	for i : float in range(NUM_BARS):
		var freq_start : float = (i * MAX_FREQ) / NUM_BARS
		var freq_end : float = ((i + 1) * MAX_FREQ) / NUM_BARS
		var magnitude : float = spectrum_instance.get_magnitude_for_frequency_range(freq_start, freq_end).length()
		bars[i].size.y = lerp(bars[i].size.y, magnitude * 1000 * 2, 0.2)  # Smooth animation
		
		var intensity : float = (magnitude*1000) / (max_freq_amp * 1000.0) if max_freq_amp > 0 else 0.0
		intensity *= 1000
		intensity = clamp(intensity, 0.0, 1.0)  # Keep within valid range

		# Get dynamic color from gradient
		var new_color : Color = color_gradient.sample(intensity)
		bars[i].color = new_color
		if flip_y:
			bars[i].scale.y = -1
	
	if shuffle_freq:
			bars.shuffle()
