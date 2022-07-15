extends Entity2D

export (int) var speed = 200
export (int) var jump_speed = -1700
export (int) var gravity = 3000
export (int) var friction = 0.1
export (int) var acceleration = 0.5

export (int) var weight_capacity = 20 

var velocity =  Vector2.ZERO
var can_move = true
var can_jump = false
var can_dash = false
var facing_left: bool

func _ready():
	Global.player = self

func get_input():
	velocity.x = 0
	var dir = 0
	if Input.is_action_pressed("right") and can_move:
		facing_left = false
		velocity.x += speed
		dir += 1
	
	if Input.is_action_pressed("left") and can_move:
		facing_left = true
		velocity.x -= speed
		dir -= 1
			
	
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		
	elif dir == 0:
		velocity.x = lerp(velocity.x, 0, friction)
	
	
#	$Melee.melee_dir = get_global_mouse_position() - global_position
#	if Input.is_action_just_pressed("shoot"):
#		$Melee.attack()
	$Laser.laser_dir = get_global_mouse_position() - global_position
	if Input.is_action_just_pressed('shoot') or Input.is_action_just_released('shoot'):
		$Laser.toggle_active()
	#@ greg here \/
	print(Global.player_parts["primary_arm"])
	match Global.blueprints[Global.player_parts["primary_arm"]]["stats"]["type"]:
		# Global.blueprints[blueprint]["stats"][<value>] to make your guns work with every one of that type, next to each case is a list of all the values you have avalable 
		"basic_gun": #{"type": "basic_gun", "damage": 5, "shoot_speed": 1.0, "shots_per_click": 4, "spacing": 0.1} (spacing is time between each bullet in a click)
			print("hii")
			if Input.is_action_just_pressed("reload"):
				$Weapon.reload()
#			if $Weapon.automatic: no weapons are auto 
#			my reaction to this information:
#                                                                                   ......''',''''.........                                                                                              
#                                                                              ...',;::cccccccllllllllcccc::;;,'....                                                                                     
#                                                                           ...',,;;::::ccclllloolllllooooolllllc:;,....                                                                                 
#                                                                       ...',,;;;;,,,;;;:::cccllllllllloooooooolllllcc:;''..                                                                             
#                                                                     ..',;;;;;;;;;::cllllllooooddddxxxxxxxxxxddddolllccc::;,'...                                                                        
#                                                                   .',;;::::ccllloodddddxxxxxxxkkkkkkkkkkkkkOOO0OOkxdoollccc::;,'...                                                                    
#                                                                ..',;::cllooodddxxxxxxxxxxxxxkkkkkkkkkkOOOkOOO000Okkxxdoolllc::;,,'...                                                                  
#                                                              ..';;::cloddxxxxxkkkkkkkkkkkkkkkOOOOOOOOkkkkkkkkkkkkxxxddooolllcc:;,,'....                                                                
#                                                            ..';:cclloddxxxxxkkkkkkkkkkOOOOOOOOOOOOOOOOOkkkkkkkxxxxxxddooolllccc::;;,,'..                                                               
#                                                           .';:llooddxxxxxxkkkkkkkkOOOOOOOOOOOOOOOOOOOOOOkkkkkxxxxdddddoooolllcc:::;;;;,'.....                                                          
#                                                         ..,:loodddxxxxxkkkkkkkkkOOOOOOOOOOO0OOO00OOOOOOOOkkkkkxxxxddddddoolllccc::;;;;;,,,''..                                                         
#                                                        .,:loddddxxxkkkkkkkkOOOOOOOOOOO00000000000000OOOOOOkkkkkxxxxddddddooollcc::;;;;;;,,,,''..                                                       
#                                                       .,clddddxxxkkkOOOOOOOO00000OOO00000000000000000OOOOOOOkkkxxxxxddddoooollcc::;;;;;;;,,;;,,..                                                      
#                                                       .:lddddxxkkkOOOOOOOO0000000000000000000000000000OOOOOOOOkkkkxxxddooooollc:::;;;;;;;,,;;;;,.                                                      
#                                                      .;ldddddxxkkkOOOOOOOO0000000KKKKKKKKKKK00KKKKK000000OOOOOOOkkkkxxdddooollc:::;;;;;;;,,,;;;,..                                                     
#                                                     .'coddddxxkkkkOOOOOOOO00000KKKKKXXXKKKKKKKKKKKKKKK000000OOOOOkkkxxxddooollcc::;;;;;;;;,,;;;,'.                                                     
#                                                     .;lddddxxkkkkOOOOOOOOO0000KKKKKXXXXXXXKKKKKKKKKKKKK00000OOOOOkkkkxxxddoollcc::;;;;;;;;;;;;;,,..                                                    
#                                                    .'coddddxkkkkkOOOOOOO00000KKKKKXXXXXXXXXXKKK0KKKKKKK000000OOOOkkkkkkxxddoolcc::;;;;;;;;;;;;;,,'..                                                   
#                                                   ..,cdxxdxxkkkkOOOOOOO0000000KKKKXXXXXXXXXKKKKKKKKKKKK0000000OOOOkkkkkkxxdoolcc::;;;;;;;;;;;;;;,,'.                                                   
#                                                   ..,cdxxxxxkkkkOOOOOO00000000KKKKKXXXXXXKKKKKKKKKKKKKK000000000OOkkkkkkxxdoolcc::;;;;;;;;;;;;;;;;,.                                                   
#                                                   ..,cdxxxxkkkkkOOOOOO000000000KKKKXXXXXKKKKKKKKKKKKKKK000000000OOOOkkkkxxdoolcc::::;;;;;;;;;;;;;;,..                                                  
#                                                   ..,lddxxxkkkkkkkkkOO000000000KKKXXXXXXXKKKK00000KKKK000KKK00000OOOkkkkxxdoolcc:::::;;;;;;;;;;;;;;'.                                                  
#                                                   ..,ldddxxxxkkkkkkkOO000000000KKKKKKKKXKKKKKKK00000KK00000000000OOOkkkkxxdollcc::::::;;;;;;;;;;;;;'.                                                  
#                                                    .'cddddxxxxxkkkkkOO000000KKKKKKKKKKKKK0000000000000000000000OOOkkkkkkxxddollccccc:::;;;;;;;;;;;;,..                                                 
#                                                    ..:dxxddxxxxxkkkOOOOOOOOOOOO0000OOOOOOOOOOOOOOOOO00OOOOOOOOOOOkkkkkkxxxxddoollllccc::;;;;;,,;;;;,..                                                 
#                                                     .;oxxddddxxxkkkkkkkkkkkxxxxxxxddddddddxxxxxxxxkkkkkkkkkkkkkkkxxxxxxxxxdddddddoollllc:;;;;,,,,,,'.                                                  
#                                                ......'codddddxxxxkkxkkkkkOOOOkkkxxdolcccccclllodddddddxxxkkxxddddoolllllllooooooddollllcc:;;;,,,,,,'.                                                  
#                                             ..,:clollclddddddxxxxxxxxxkOO00OOkkxdollllllcc:;;:clloooodxxkxxdollcc:;;;;::cloooooooolcccc:::;;;;,,,,,,..                                                 
#                                            ..,:;;ldddxkkxddoddxxxxxxxxxxxdol:;,,''',;:c:::;;;;coodxxkOOOkkxolcc:;,,,,,;:cclooooooollcc:;;;;;;;;,,;;;;''...                                             
#                                           ..';;'':ooodxxxdoooddxkkkxkxdoc:cc:,....',:lll:;;:cldkO0000000Okxolcc:;''...'''....''',;::::;;;;;;;,,;;::c:;,,'.                                             
#                                           ..,;:;;lxxdoodddooooddkkkxxxddxkkkkxol::coddxddoodxO0000KKKKK0Okxdlcccc;,,,;clc,......',,',,;;;::;,,,;:clc:;,,'.                                             
#                                           ..';:::lxxxxdoooooooodxkOOkkkO0000000OkkkxxxxxddxkO0KKKKKKKKK0kxdoccclccccloxxxdlcccccllc:;;;;::::;,,:clolc;,,'.                                             
#                                            ..;cccoddol:::lllloodxkO0OOOOOO000000OOOkkkkkkkOO00KKK000000Okxolcccccccloddxxxdddddooollc::::::;;,;:lool:,',..                                             
#                                 ....   .    .':clddoc;,,:oolllodxkkOO000000000000OOOkOO0KKKKK00000000KKOxdlccccccloodddxxxxddddooolcc::::::;,,,;cllc:,'..                                              
#                                  ......   .  .';lddoc:;:ldxolllodxkOO000KKKKKKKK0000KKXXXXKK00000OO0000Oxolc:::cclodddxxxxxddddooolccc:::::;,,,,;:cc:,..                                               
#                                ........   ..  ..;ldddolloxxooooodxxxkOO00KKXXXXXXKXXXXXXXKK00000OOO000OOxdolcccccllodxxkkxxxxxddoollllcc::;;,,,,;:c:;..                                                
#                     .............................,ldddddxxxoooooddddxkkOO0KKXXXXXXXXKKK0OkkkOOOOO00000OOxdolcccccccldxkkkxxxxxdddddollcc:;;,,,;;;::;..                                                 
#         ....       ...............................'codxxxkxoooooodddxxkkOO00KKKKKKKK0kxooodkOOOOO00K00Okxddoccccc::clodxkkkkkxxdddolc::::;;,;;::::;'.                                                  
#        .....   .....................................,cdkkkxooooodddddxxxkkOO00000OkdlcccldxkkkkOO0000OOkkxdoccccc:::;:cloxkkkxxddolc:;;;;;;;:ccc;'..     ..                                            
#......................................................'cdkkxooooodddddddxxkkkkkkkxdl:;:ldxkxlc::lodxxxxddoooc:,,,,,;::;;;:cldxxddolc:;;;;;,,;:cc;'.                                                     
#.......................................................'cdddooooodddddddddxxxxxxxdolloxO00Okdlc::ccccc:;,,;;;;,''',;::::;;,;coooolc::;;;;;,,;:::'.              ....      ...                           
#.........................................................,;:loooodddddddddddddddddddxkOOO000000OOkxdoocc;,,;;::;;;;::::::;,,;:cccc:;;;;;;,,,,,,'.      ..     .................. ....                   
#............................................................:lloooddddooodddddooddxxkkkOO00000000OOkkkxxdlcc::::::::::::::;,,,;::::;;;;;;,,''...               ............................             
#............................................................;:clooodooooooooolllldxkkkkkOOOOOOOOOOkxddddxddooollccccc::::::;;,,;;;;;;;;;;,,'..    ..... ......................................          
#............................................................,;clooooooooooollc:cloddxxxxkkkkOOOkkkxxdddxxxdddoollcccc:::::::;,,',;;;;;;;;,'..   ...............................................         
#............................................................';cllooooooddooolc::cccllooooooooooolllllllllllccc::;;;;;;;;;;;,,,'',;;;;;;;,,'......................................................       
#............................................................,;:cllooddooddddoollcccccclcc:::::;;,'''''''''''''''''''',,;;,,,''',;;:;;;;;,'..............................................................
#............................................................,:cccclloddddddxxxxddddxxxxddoooooollcc:::::::::::;;;;;;;;:::::;;,;;::::;;;;'...............................................................
#............................................................':llcccloooddddddxxxxxxxxxxxxddddxxxxddddooooolllcc:::::::c:::::::::::::;;;,..  ............................................................
#............................................................':oolloooooooodddddxxxxxxkkkxxxddddooolllllcc:::::::::::::c:::::::::::::;;,'.. .............................................................
#...........................................................';lxxdodooooooooodddxxxxxxxxkkkxxxxddoooollllllccccccccllcccc:::::::::::;;,'.................................................................
#.........................................................',;cd00xddoooooooooodddxxxxxxkkkkkkkkxxxddddooooooooooooooolccc:::::::::::;,...................................................................
#.......................................................',;;:cd0X0kdddooooooooddddxxxxkkkkkkkkkkkkxxxxxxddddddddddddolccc:::::::::;;,....................................................................
#.....................................................',;::::coOKXKOxdoolllollllooooddxxxxxkkkkkkkxxxxxddddddddddddolc:::::::;;;;;,......................................................................
#..................................................',;;;:cccccloONNX0kdoooc:;,,;;::clloodddxxxxddddooooooooddddoollcc::;;;;;;,,,,,.......................................................................
#................................................',;::::::::::cco0NNNKkddol:;'.....',;cclllooooooolllllllllllllccc::::;;,,;;,;:cc:'......................................................................
#..............................................',;;::::::::::::ccdOXNNX0Oxdol:,'...''',,,;;;::::::::::::::::::;;;;;;;;;;;;;;;:oxxo;......................................................................
#...........................................'',,;;:::::::::::::::cokKNWNXKOxdol::;;;,,,,'''''''''''''''',,,,,,,,,,;;;;;;;;;;:cdO0kc......................................................................
#.......................................''',,;;;::;;;;;;;;;;;;;;;;:cdOXWWWNX0kdolcc:;;;;,,''..........''''''''',,;;;;:::::::cokKKOo,''...................................................................
#..................................''',,;;:::;;;;;;;:::;;;;;;;;;;;;::lOXNWWWNX0xdolc::;;;,,,,,''.''',,,'''..'',,;;;::::::::cokKXXOo;,,,,,,,'.............................................................
#..............................'',;::cccccc::;,;::::::::::::;;;;;::;;:lxOXNWWWNXKOxolc:::;;;;;,,,,,,;;;,.....',;;;::::::::cokKXNXOl;',;;;;;;;;,''........................................................
#.........................'',,;::ccllllllcc::;;::cccc:::::::::::::::::ccoxKNWWWWWNX0kdolc::::::;;;;;:::;'....',;;:::::::cldkKXNNKkc,',,,,;;:::::;,,''....................................................
#....................''',,;::cllllllllllcccc::::ccccccccc::::::cc:::ccccclx0XNWWWWWWNXKOxdlcccccc::::::;,,''',;;::::::cldxOXNNNNKk:..,,,,,;;;::::;;;;;;;;,,,''...........................................
#...............'',,;;:ccllllllllllcccccccccc:::ccccccccccccccccc:::::cclllox0NWWWWWWWWNXX0kdlccc::::::::;;;;;:::cccclok0KXNNNNNKx;..,,,;;,,,;;;;;:::::::ccccc::;;,,''''.................................
#..........',,;;:ccllloooooolllllcccccccccccc:::ccccccccccccc::::cc::::cccllloOXWWWWWWWWWWWNXK0kdlccc:ccc::::::::cclox0KXXNNNNNX0d,..,,,;,,;;;;;;;;;;;::ccccclllcccccc::;;;,,,''''.......................
#...''',,;;:clloooooooooooooolllccccccccccccccc:::cccccccccccccccccc:::ccclc::lkKNWWWWWWWWWWWWWNXKOxdoollc:c:::ccldkOKXNNNNNNNNXOl'..',,;;;;;;;;;;;;;;:::cccccccccccccccccccccccc::::;;,,'''.............
#',,;:clllooodddddoooooollllllllcccccccclcccccc:::cccccccccccccccccccccccccc::cldOXWWWWWWWWWWWWWWWWNXK0kdc:::::coxOKXXXNNNNNNNNXkc' ..,,;;;;;;;;;;;;;;::::ccccccc:::::::cccccllcccllllllcccc::;;;,,''....
#clllloooddddddddoooollllcclllllcccccccclllcccc:::cccccc::::cccccccccccccccc:::ccokXWWWWWWWWWWWWWWWWWWNKkl,'...',cdOXNNNNNXNNNNXkc.  ..',;,,,;;;;;;;;;;;:::cccccc::::;;;::::ccccccccccccclllllcccc:;,,,,'
#oooooooooddooooooolllccccccclllcccccccclllcccc:::cccc:::::::cc:ccccccccccc:::::cclkXNWWWWWWWWWWWWWWWNXOdc;'.......;lkKXNNNNNNNXkc.  ..',,,,,;,;;;;;;;;;;;:::ccc:::::;;;;;;;::::::ccccccccllllllcc:,,',;;
#oooooooooooolllllllccccccccccllcccccccccllcccc::::ccc::c::::cccccccccc::::ccc::c::lx0NWWWWWWWWWWWWN0xo:,,;;;,..... .;oOXNNNNNNXkc'  ...''',,,,;;;;;;;;;;;;;:::::::::::;;,,,;;;;::::::::::cccccccc:;'..';
#ooooooooooollllllllcc::::ccccccccccccccccccccc:::::::::::::::cc:::cc:::::ccccc:::cclx0NWWWWWWWWWWXkl,..:l::clc,.....':oOKXNNNXKkc.  ...';;,,,;,,;;;;;;;;;;;;;:::::::::;;;,,,,,;;;;;:::::::::cccccc:,...,
#oooooolllllllllllccccc:::ccccccccccccccccccccc:::::::::::::::::::::::::::cccccc:ccccco0NWWWWWWWWKo,..';dkclkkkd:;,,;;clxOKKXXKKOd:,;;;::cc;clc::cllclc;;;;;;;;;;::::::;;;,,,,,,,;,,;;;;;;;:::::ccc:,'...
#lllllllllllllllcccccccccccccclllccccccccccccc::;;::::::;;;;::::;;;;:::::cccccc::ccc::cx0XNWWWWNKxc..,ldd:':dkkl;:::ccccldk0KKXK0kc:lccclllclocoocllcl:,;;;;;;;;;;;::::::;;,,,,,,,,,,,,,,,;;;;::ccc:;'. .
#lllllllllllllllcccccccccccccclllccccccccccccc::;;;;;;;:::;;;;:;;;;:::::::ccccccccccccccokKNWWXOdo:....''..;:c:;,'';cooc;:oOXXXXKx:,;:c:::;;:;;c:,;;,;;;;;;;;;;;;;;;::::::;;,,,,,,,,,,,,,,,,,;::cc::;,. .
#lllllllllllllllccc::ccccccccclllllcccccllcccccc::::;;,,;;;;;:::::::::::::::ccccc:ccccc::lx0XNKOdolc;'.....,;;;;,..':oxxdoodOKNNKk:. .,;;:::;;,,;,,,,,;;,,,,,,,,,;;;;;;::::;;;,,,',,,,;,,,,,,,;;:::::;'  
#				if Input.is_action_pressed("shoot"):
#					$Weapon.fire()
#			else:
			#if Input.is_action_just_pressed("shoot"):
				#$Weapon.fire()
			$AimPosition.position = (get_local_mouse_position()).normalized() * 64
			$Weapon.shoot_dir = get_global_mouse_position() - global_position
			
		"basic_melee": # {"stats": {"type": "basic_melee", "damage": 10, "swing_speed": 0.4, "length": 0.75}
			pass
		"close_melee": # {"type": "close_melee", "dps": 60, "length": 0.5} (think chainsaw, constant dps at a short tange)
			pass
		"laser_gun": # {"type": "laser_gun", "dps": 40} (inf range deathbeam does constant dps)
			pass
			
func _physics_process(delta: float) -> void:
	
	get_input()
	velocity.y += gravity * delta
	velocity = move(velocity, delta)
	velocity.x = lerp(velocity.x, 0, 0.2)


func _input(event):
	if event.is_action_pressed("collect") and can_move:
		for b in $Area2D.get_overlapping_areas():
			b = b.get_node("../")
			if b.is_in_group("BunkerEntrance"):
				for blueprint in range(Global.items["blueprint"]["stored"]):
					Global.change_item_count("blueprint", -1)
					Global.blueprints[Global.items["blueprint"]["type"][blueprint]]["has_blueprint"] = true
					print("added blueprint ", Global.items["blueprint"]["type"][blueprint])
					
				for item in Global.items.keys():
					if item != "blueprint":
						Global.items[item]["bunker"] += Global.items[item]["stored"]
						print("bunkered ", Global.items[item]["stored"], " ", item)
						Global.items[item]["stored"] = 0
				
				can_move = false
				Global.inventory_controller.update_inventory()
				Global.transition()
				Global.root.save_scene()
				yield(get_tree().create_timer(1.0), "timeout")
				get_tree().change_scene("res://Scenes/Bunker.tscn")
				
			elif b.is_in_group("Item") and Global.change_item_count(b.item_name, 1):
				if b.item_name == "blueprint":
					Global.items["blueprint"]["type"].append(b.blueprint)
				b.queue_free()
				break
	
	if event.is_action_pressed("jump") and can_move and can_jump:
		if is_on_floor():
			velocity.y = jump_speed
	
		


