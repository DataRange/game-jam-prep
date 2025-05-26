extends Control

var failures = [
  "You lined up the shot, breath steady, heart calm. You pulled the trigger without doubt. And then — silence. Not triumph, not relief. Just a name you weren’t supposed to know. A face that wasn’t on the list. You didn’t miss. But you were wrong.",

  "They told you to wait, to be sure. But you saw a movement — enough to act, enough to end it. The smoke cleared, and your target was still alive… watching. One bullet. One mistake. Now they know you’re coming.",

  "You memorized the face, rehearsed the timing, calculated the escape. But the person who fell wasn’t the one you trained for. They dropped with wide eyes, confused, innocent. And now every step echoes with their silence.",

  "The game gives you one shot — not for mercy, not for warning. Just one. And when it goes to the wrong heart, the wrong soul, it doesn’t just end a life. It stains yours.",

  "You squeezed too soon. You flinched at the sound. You forgot the wind. Maybe it was nerves, maybe it was fate. But your target walks on, unaware — and the one who took their place is gone forever.",

  "You can't explain it away. No rewind, no second chance. The one bullet left your hands and found someone else. A bystander. A nobody. And now their absence screams louder than your mission.",

  "You expected chaos, a chase, maybe even applause. But after your shot, there was nothing. Just a body falling in the wrong direction. You thought it would feel like a win. It didn’t.",

  "No one told you they had a twin. No one said the target wore blue today instead of red. But excuses don’t matter to the person you left bleeding on the concrete — and now every shadow looks like vengeance.",

  "You hesitated — not long, just a breath. But long enough to question. Long enough to miss. Long enough to die next.",

  "You fired. You hit. Clean, silent, perfect. Except now, you’re just a murderer. Not a hero. Not a hunter. Just someone who traded an innocent life for a job that was never finished."
]

var success = [
  "One shot. One life. You didn’t miss — and they never saw it coming.",

  "No noise, no mess. Just precision. Target down.",

  "Clean, silent, perfect. That’s how it’s done.",

  "You waited, watched, and struck. They never stood a chance.",

  "One bullet. One heartbeat. One confirmed kill.",

  "You made it look easy. Professional work.",

  "The shot echoed once — and that was the end of them.",

  "No hesitation, no error. That’s what mastery looks like.",

  "Target eliminated. Mission clean.",

  "Sharp eyes. Steady hand. Perfect execution.",

  "Your mark is gone. No alarms, no witnesses — just results.",

  "You had one chance. You didn’t waste it.",

  "One shot, one ghost. You’re the shadow they’ll never catch.",

  "Mission complete. Your reputation just grew.",

  "Bullseye. No follow-up needed."
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_world_civilian_killed() -> void:
	show()
	$LoseSound.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$"Panel/Title Text".text = "You Killed a Civilian"
	$Panel/Description.text = failures[randi_range(0,9)]
	pass # Replace with function body.


func _on_world_target_acquried() -> void:
	show()
	$WinSound.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$"Panel/Title Text".text = "Target Acquired"
	$Panel/Description.text = success[randi_range(0,14)]
	pass # Replace with function body.
