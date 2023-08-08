extends Node2D

var ammo = 20

var magSize = 20

var reloading = false

var cooldownOver = true

var bullet = load("res://games/flash_ttt/assets/weapons/bullets/bullet/bullet.tscn")

var pellet = load("res://games/flash_ttt/assets/weapons/bullets/pellet/pellet.tscn")

var weapons = {"pistol": {"damage": 20.0, "speed": 1750.0, "magSize": 10, "bulletType": "bullet", "shotType": "single", "shotAmount": 1, 
							"bounces": 1, "firingMode": "semi", "bulletRange": 1000.0, "firingCooldown": .1, "barrelPos": 51},
				"shotgun": {"damage": 8.0, "speed": 750.0, "magSize": 5, "bulletType": "pellet", "shotType": "spread", "shotAmount": 10, 
							"bounces": 0, "firingMode": "semi", "bulletRange": 350.0, "firingCooldown": .75, "barrelPos": 41},
				"machineGun": {"damage": 15.0, "speed": 1500.0, "magSize": 30, "bulletType": "bullet", "shotType": "single", "shotAmount": 1, 
							"bounces": 0, "firingMode": "auto", "bulletRange": 750.0, "firingCooldown": .1, "barrelPos": 51},
				"sniper": {"damage": 75.0, "speed": 3000.0, "magSize": 7, "bulletType": "bullet", "shotType": "single", "shotAmount": 1, 
							"bounces": 3, "firingMode": "semi", "bulletRange": 2000.0, "firingCooldown": 1.75, "barrelPos": 51}}

var activeWeapon = "pistol"

#var bullet = preload("res://scenes/Bullet.tscn").instance()

func switchWeapon(newWeapon):
	activeWeapon = newWeapon
	cancelReload()
	magSize = weapons[newWeapon].magSize
	updateAmmo(magSize)
	cooldownOver = false
	$ShotCooldownTimer.wait_time = weapons[activeWeapon].firingCooldown
	$ShotCooldownTimer.start()
	$Barrel.position = Vector2(weapons[newWeapon].barrelPos, 0)
	updateWeaponUI()

func updateWeaponUI():
	get_parent().get_node("PlayerUI").updateWeapon(activeWeapon)

func updateAmmo(newAmmo):
	if get_parent().alive:
		ammo = newAmmo
		get_parent().get_node("PlayerUI").updateAmmo(ammo)

func _on_ReloadTimer_timeout():
	reloading = false
	updateAmmo(magSize)

func reload():
	if not reloading:
		reloading = true
		$ReloadTimer.start()

func cancelReload():
	reloading = false
	$ReloadTimer.stop()

func _on_Cooldown_timeout():
	cooldownOver = true

func fire():
	shoot(weapons[activeWeapon])

func spawnBullet(gunData, pos, rot):
	var newBullet: Node
	if gunData.bulletType == "pellet":
		newBullet = pellet.instance()
	else:
		newBullet = bullet.instance()
	rpc("remoteShoot", gunData, pos, rot)
	remoteShoot(gunData, pos, rot)

func shoot(gunData):
	if ammo < 1:
		reload()
	if ammo > magSize:
		ammo = 0
	if not reloading:
		if cooldownOver == true:
			if ammo > 0:
				if gunData.shotType == "spread":
					for i in gunData.shotAmount:
						spawnBullet(gunData, $Barrel.global_position, (global_rotation - (PI / 4) + ((PI/2/gunData.shotAmount) * i))) #(global_rotation - (PI/4) + ((PI/ 2 / gunData.shotAmount) * i)))
				else:
					spawnBullet(gunData, $Barrel.global_position, global_rotation)
				cooldownOver = false
				updateAmmo(ammo - 1)
				$ShotCooldownTimer.start()

puppet func remoteShoot(gunData, pos, rot):
	var newBullet = bullet.instance()
	if gunData.bulletType == "pellet":
		newBullet = pellet.instance()
	newBullet.bounces = gunData.bounces
	newBullet.damage = gunData.damage
	newBullet.speed = gunData.speed
	newBullet.bulletRange = gunData.bulletRange
	newBullet.shooter = get_parent().name
	newBullet.start(pos, rot)
	get_parent().get_parent().add_child(newBullet)

func handleWeaponInput():
	if get_parent().is_network_master() and get_parent().alive:
		if Input.is_action_just_pressed("1"):
			switchWeapon("pistol")
		if Input.is_action_just_pressed("2"):
			switchWeapon("shotgun")
		if Input.is_action_just_pressed("3"):
			switchWeapon("machineGun")
		if Input.is_action_just_pressed("4"):
			switchWeapon("sniper")
		if Input.is_action_just_pressed("r"):
			reload()
		if weapons[activeWeapon].firingMode == "semi":
			if Input.is_action_just_pressed("left_click"):
				fire()
		else:
			if Input.is_action_pressed("left_click"):
				fire()

func _ready():
	switchWeapon("pistol")

func _physics_process(delta):
	handleWeaponInput()
