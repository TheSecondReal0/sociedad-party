extends CanvasLayer

func updateAmmo(newAmmo):
	$Ammo.text = "Ammo: " + str(newAmmo)

func updateHealth(newHealth):
	$Health.text = "Health: " + str(round(newHealth))

func updateWeapon(newWeapon):
	$Weapon.text = str(newWeapon)

func updateInteraction(newText):
	$Interaction.show()
	$Interaction.text = newText
