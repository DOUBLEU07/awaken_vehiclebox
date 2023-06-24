Config = {}

Config = {}
Config.WebHookCarDel		= ""
Config.WebHookCarPoud		= ""
Config.DepositCarBlip		= 'Deposit Car'
Config.DepositCarGarages	= true
Config.UndepositPrice 	    = 0	
Config.Coodown				= 1
Config.DrawDistance 		= 100
Config.DepositMarker 	= { type = 28, r = 250, g = 0, b = 0, x = 30.0, y = 30.0, z = 30.0 }
Config.UnDepositMarker = { type = 30, r = 0, g = 255, b = 0, x = 1.0, y = 1.0, z = 1.0 }
Config.ModelNPC = 's_f_y_casino_01'
Config.BlipDepositCar = {
	Sprite = 58,
	Color = 1,
	Scale = 2.0
}
Config.DepositCar = {
	Orange = {
		Blips = false,
		DepositPoint = { x = 2856.578, y = 4599.101, z = 48.002 },
		SpawnDepositPoint = {
			{ coords = vector3(2810.678, 4565.952, 46.031), heading = 110.16, radius = 10.0 },
			{ coords = vector3(2802.222, 4552.689, 46.158), heading = 104.05, radius = 10.0 },
		},
		UnDepositPoint = { x = 2821.841, y = 4589.519, z = 46.246 },
		key = "Orange"
	}, 

	chicken = {
		Blips = false,
		DepositPoint = {x = 2313.493, y = 5119.419, z = 48.902},
		SpawnDepositPoint = {
				{ coords = vector3(2341.552, 5096.982, 46.655), heading = 139.4, radius = 10.0 },
				{ coords = vector3(2315.961, 5068.666, 45.558), heading = 131.78, radius = 10.0 },
			},
		UnDepositPoint = {x = 2330.720, y = 5085.794, z = 45.983},
			key = "chicken"
	},
	

	Rice = {
		Blips = false,
		DepositPoint = { x = 1959.493, y = 4854.373, z = 45.450 },
		SpawnDepositPoint = {
				{ coords = vector3(1987.926, 4890.238, 43.140), heading = 124.26, radius = 10.0 },
				{ coords = vector3(2006.613, 4869.334, 43.149), heading = 130.29, radius = 10.0 },
			},
		UnDepositPoint = { x = 1985.134, y = 4864.107, z = 44.588 },
			key = "Rice"
	},

	Mushroom = {
		Blips = false,
		DepositPoint = { x = 1050.142, y = 4275.574, z = 38.102 },
		SpawnDepositPoint = {
				{ coords = vector3(1029.283, 4340.839, 40.829), heading = 33.04, radius = 10.0 },
				{ coords = vector3(1043.655, 4350.377, 39.087), heading = 36.58, radius = 10.0 },
			},
		UnDepositPoint = { x = 1031.593, y = 4314.613, z = 41.130 },
			key = "Mushroom"
	},
	salad = {
		Blips = false,
		DepositPoint = { x = 311.2954, y = 4315.372, z = 47.593 },
		SpawnDepositPoint = {
				{ coords = vector3(298.6294, 4348.866, 49.773), heading =  1.05, radius = 10.0 },
				{ coords = vector3(278.0973, 4338.688, 47.411), heading = 24.27, radius = 10.0 },
			},
		UnDepositPoint = { x = 312.4121, y = 4344.623, z = 49.995 },
			key = "salad"
	},
	garlic = {
		Blips = false,
		DepositPoint = { x = 563.2157, y = 6496.843, z = 29.804 },
		SpawnDepositPoint = {
				{ coords = vector3(587.6029, 6525.411, 28.070), heading =  69.94, radius = 10.0 },
				{ coords = vector3(564.7438, 6530.672, 27.924), heading = 69.59, radius = 10.0 },
			},
		UnDepositPoint = { x = 580.1802, y = 6516.685, z = 29.573 },
			key = "garlic"
	},
	space_stone = {
		Blips = false,
		DepositPoint = { x = -820.382, y = 5777.998, z = 5.4251 },
		SpawnDepositPoint = {
				{ coords = vector3(-783.257, 5754.395, 6.4038), heading =  254.69, radius = 10.0 },
				{ coords = vector3(-768.269, 5767.610, 8.3462), heading = 254.11, radius = 10.0 },
			},
		UnDepositPoint = { x = -781.741, y = 5762.366, z = 6.1425 },
			key = "space_stone"
	},
	wood = {
		Blips = false,
		DepositPoint = { x = -647.765, y = 5480.004, z = 51.798 },
		SpawnDepositPoint = {
				{ coords = vector3(-656.419, 5447.414, 50.539), heading =  101.56, radius = 10.0 },
				{ coords = vector3(-600.422, 5464.441, 58.5029), heading = 119.32, radius = 10.0 },
			},
		UnDepositPoint = { x = -659.614, y = 5459.319, z = 51.397 },
			key = "wood"
	},
	jelly = {
		Blips = false,
		DepositPoint = { x = -1631.85, y = 4736.761, z = 53.338 },
		SpawnDepositPoint = {
				{ coords = vector3(-1588.42, 4753.909, 51.020), heading =  0.9, radius = 10.0 },
				{ coords = vector3(-1614.35, 4792.448, 52.455), heading = 290.29, radius = 10.0 },
			},
		UnDepositPoint = { x = -1626.19, y = 4757.464, z = 52.155 },
			key = "jelly"
	},
	durian = {
		Blips = false,
		DepositPoint = { x = -2528.84, y = 2682.604, z = 2.9348 },
		SpawnDepositPoint = {
				{ coords = vector3(-2500.63, 2714.242, 2.9334), heading =  19.19, radius = 10.0 },
				{ coords = vector3(-2568.51, 2723.250, 2.8435), heading = 349.03, radius = 10.0 },
			},
		UnDepositPoint = { x = -2530.81, y = 2655.697, z = 2.9174 },
			key = "durian"
	},
	honey = {
		Blips = false,
		DepositPoint = { x = -298.673, y = 2842.921, z = 55.420 },
		SpawnDepositPoint = {
				{ coords = vector3(-271.965, 2803.698, 55.223), heading =  291.21, radius = 10.0 },
				{ coords = vector3(-228.595, 2835.043, 44.258), heading = 30.9, radius = 10.0 },
			},
		UnDepositPoint = { x = -273.098, y = 2839.130, z = 53.891 },
			key = "honey"
	},
	mine = {
		Blips = false,
		DepositPoint = { x = 2952.343, y = 2786.989, z = 41.408 },
		SpawnDepositPoint = {
				{ coords = vector3(2978.430, 2806.623, 43.858), heading =  19.9, radius = 10.0 },
				{ coords = vector3(2997.578, 2780.548, 43.358), heading = 26.68, radius = 10.0 },
			},
		UnDepositPoint = { x = 2960.628, y = 2819.343, z = 43.451 },
			key = "mine"
	},
}

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}