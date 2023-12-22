extends CanvasLayer

# refs
@onready var label_watch_out = $label_watch_out
@onready var label_starved = $label_starved
@onready var label_starve_countdown = $container_starve_countdown/label_starve_time

# resources
@onready var label_setting_time_normal = load("res://themes/starve_time_label_settings.tres")
@onready var label_setting_time_highlight = load("res://themes/starve_time_r_label_settings.tres")

# highlight
var is_highlighting_starve_countdown = false

# const
const highlight_countdown_at_time = 10.0


func _ready():
	self.reset()


# --
# public methods

func reset():

	# hide labels
	self.hide_label_watch_out()
	self.hide_label_starved()

	# reset
	self.highlight_starve_countdown_off()

	# show
	$container_starve_countdown.show()

	# show canvas
	self.show()


func set_starve_countdown(ct):

	var t1 = int(int(ct) / 10.0)
	t1 = str(t1) if t1 else "  " 
	var t2 = str(int(ct) % 10)
	var t3 = str(int(ct * 10) % 10)

	# time string
	var time_str = "" + t1 + t2 + "." + t3

	#round(num * pow(10.0, digit)) / pow(10.0, digit)

	# set time
	label_starve_countdown.text = time_str


func update_starve_countdown(actual_starving_time : float):
	
	# set time
	self.set_starve_countdown(actual_starving_time)
	
	# highlight
	if not is_highlighting_starve_countdown:

		# highlight on
		if actual_starving_time < highlight_countdown_at_time:
			self.highlight_starve_countdown_on()


func highlight_starve_countdown_on():
	if is_highlighting_starve_countdown: return
	is_highlighting_starve_countdown = true
	label_starve_countdown.set_label_settings(label_setting_time_highlight)


func highlight_starve_countdown_off():
	if not is_highlighting_starve_countdown: return
	is_highlighting_starve_countdown = false
	label_starve_countdown.set_label_settings(label_setting_time_normal)


func show_label_watch_out():
	label_watch_out.show()


func hide_label_watch_out():
	label_watch_out.hide()


func show_label_starved():
	label_starved.show()


func hide_label_starved():
	label_starved.hide()
