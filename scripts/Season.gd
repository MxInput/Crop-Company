class_name Season
var time_in
var name

var seasons_list = ["Spring", "Summer", "Fall", "Winter"]

func clock(time_change : float):
	time_in += time_change

func change():
	match name:
		"Spring":
			name = "Summer"
			time_in = 0
		"Summer":
			name = "Fall"
			time_in = 0
		"Fall":
			name = "Winter"
			time_in = 0
		"Winter":
			name = "Spring"
			time_in = 0
