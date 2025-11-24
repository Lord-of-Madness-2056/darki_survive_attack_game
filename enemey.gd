extends Node2D


var room_order = ["room7", "room6", "room5", "room4", "room3", "room2", "room1", "office"]  # office — последняя
# Позиции комнат (замените на свои координаты)
var positions = {
	"office": Vector2(555, 383),
	"room1": Vector2(1929, -521),
	"room2": Vector2(2695, -336),
	"room3": Vector2(4266, -428),
	"room4": Vector2(2088, 227),
	"room5": Vector2(3096, 329),
	"room6": Vector2(3998, 146),
	"room7": Vector2(3379, 868)

}

# Текущая позиция аниматроника
var current_room = "room7"
# Текущая камера игрока (обновляйте из другой сцены через сигнал)
var current_camera = "office"  # Начнем с room1

@onready var game = $Gameover
@onready var sprite = $Sprite2D
@onready var timer = $Timer

func _ready():
	# Установите начальную позицию
	position = positions[current_room]
	# Настройте таймер: случайный интервал 5-15 секунд
	timer.wait_time = randf_range(1, 1.1)
	timer.start()
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout():
	# Выберите случайную следующую комнату (кроме текущей)
	var possible_rooms = positions.keys().filter(func(r): return r != current_room)
	var next_room = possible_rooms[randi() % possible_rooms.size()]
	
	# Телепортируйтесь только если игрок не смотрит на текущую комнату
	if current_room != current_camera:
		current_room = next_room
		position = positions[current_room]
		# Опционально: сыграйте звук телепортации
		print("Аниматроник телепортировался в ", current_room)
		if current_room == "office":
			print("Аниматроник в офисе! Игра окончена.")
			game.visible = true
	# Перезапустите таймер с новым рандомным временем
	timer.wait_time = randf_range(1, 1.1)
	timer.start()

# Функция для обновления текущей камеры (вызывайте из системы камер)
func update_camera(new_camera: String):
	current_camera = new_camera
	# Если аниматроник в комнате игрока, можно добавить логику атаки
	if current_room == "office":
		print("Аниматроник в офисе! Игра окончена.")
		# Здесь вызовите сигнал или функцию для окончания игры
