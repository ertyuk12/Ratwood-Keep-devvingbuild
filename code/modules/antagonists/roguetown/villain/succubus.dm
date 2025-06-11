/// DEFINITIONS ///
//#define SUCC_LEVEL_ONE 5
//#define SUCC_LEVEL_TWO 10
//#define SUCC_LEVEL_THREE 15
//#define SUCC_LEVEL_FOUR 25
//#define SUCC_LEVEL_FIVE 50 //functionally, ascension. If you have this many people relying on one rear, you probably have bigger issues

//used VL as a base, so I wouldn't have to manually set up a antag datum
GLOBAL_LIST_EMPTY(succubus_objects)

/datum/antagonist/succubus
	name = "Succubus"
	roundend_category = "Succubi"
	antagpanel_category = "Succubus"
	job_rank = ROLE_SUCCUBUS
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "Sucb"
	confess_lines = list(
		"I WILL PROVIDE PLEASURE TO ALL!",
		"ALL WILL FALL FOR ME!",
		"I LOVE ALL, AND ALL WILL LOVE ME!",
	)
	rogue_enabled = TRUE
//	var/isspawn = FALSE
//	var/disguised = FALSE
//	var/ascended = FALSE
	var/starved = FALSE
//	var/sired = FALSE
	var/totalensnared = 0
	var/totalessence = 0
	var/succlevel = 0
	var/vitae = 500
	var/vmax = 1000
//	var/obj/structure/vampire/bloodpool/mypool
	var/last_transform
	//var/cache_skin
	var/obj/item/organ/eyes/cache_eyes
	var/cache_eye_color
//	var/cache_hair
//	var/staked = FALSE

/datum/antagonist/succubus/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
//	if(istype(examined_datum, /datum/antagonist/enchanted))
//		return span_boldnotice("A charmed creature.")
	if(istype(examined_datum, /datum/antagonist/succubus))
		return span_boldnotice("Child of Baotha!")

/datum/antagonist/succubus/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	add_antag_hud(antag_hud_type, antag_hud_name, M)

/datum/antagonist/succubus/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	remove_antag_hud(antag_hud_type, M)

/datum/antagonist/succubus/on_gain()
	var/datum/game_mode/C = SSticker.mode
	C.succubi |= owner
	. = ..()
	owner.special_role = name
	ADD_TRAIT(owner.current, TRAIT_NOSTAMINA, "[type]")
	ADD_TRAIT(owner.current, TRAIT_NOHUNGER, "[type]")
	ADD_TRAIT(owner.current, TRAIT_TOXIMMUNE, "[type]")
	ADD_TRAIT(owner.current, TRAIT_BEAUTIFUL, "[type]")
	ADD_TRAIT(owner.current, TRAIT_EMPATH, "[type]")
	ADD_TRAIT(owner.current, TRAIT_DEATHBYSNUSNU, "[type]")
	ADD_TRAIT(owner.current, TRAIT_SUCCUBUS, "[type]")
	ADD_TRAIT(owner.current, TRAIT_DEATHBYSNUSNU, "[type]")
	ADD_TRAIT(owner.current, TRAIT_DECEIVING_MEEKNESS, "[type]")

	for(var/obj/structure/fluff/traveltile/succubus/tile in GLOB.traveltiles)
		tile.show_travel_tile(owner.current)
	owner.current.cmode_music = 'sound/music/combat_vamp.ogg'
	succ_look()
	///owner.current.AddSpell(new /obj/effect/proc_holder/spell/targeted/transfixsucc) (if one of you guys can get it working, sure! For now, though...we charm through touch (see sex_action.dm)
	owner.current.AddSpell(new /obj/effect/proc_holder/spell/targeted/succ_rejuv)
	owner.current.verbs |= /mob/living/carbon/human/proc/succubus_telepathy
//	if(isspawn)
	//	owner.current.verbs |= /mob/living/carbon/human/proc/alter_button
//		owner.current.verbs |= /mob/living/carbon/human/proc/disguise_button
	//	add_objective(/datum/objective/vlordserve)
//		finalize_vampire_lesser()
	//	for(var/obj/structure/vampire/bloodpool/mansion in GLOB.vampire_objects)
//			mypool = mansion
//		equip_spawn()
//		greet()
	//	if(!sired)
		//	addtimer(CALLBACK(owner.current, TYPE_PROC_REF(/mob/living/carbon/human, spawn_pick_class), "VAMPIRE SPAWN"), 5 SECONDS)
		// All vampyre spawn consider the vampyre lord special
	for(var/datum/mind/succubus in C.succubi)
		if (succubus.special_role == "Succubus")
			owner.add_special_person(succubus.current, "#DC143C")
				// Don't break - an admin may need to create a second vampyre lord
	forge_succubus_objectives()
	finalize_succubus()
	//	owner.current.verbs |= /mob/living/carbon/human/proc/demand_submission
	//	owner.current.verbs |= /mob/living/carbon/human/proc/punish_spawn
	//	for(var/obj/structure/vampire/bloodpool/mansion in GLOB.vampire_objects)
	//		mypool = mansion
	equip_lord()
//	addtimer(CALLBACK(owner.current, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "SUCCUBUS"), 5 SECONDS)
	greet()
		// Vampyre Lord is special to all vampyre spawn
//		for(var/datum/mind/thrall in C.succubi)
//			if (thrall.special_role == "Enchanted")
//				thrall.add_special_person(owner.current, "#DC143C")
//		// And to all death knights

	return ..()

// OLD AND EDITED
/datum/antagonist/succubus/proc/equip_lord()
	//owner.adjust_skillrank(/datum/skill/magic/blood, 3, TRUE)
//	owner.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
//	owner.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
//	H.mind.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
//	H.mind.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
//	H.mind.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
//	H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
//	owner.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
//	owner.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
//	pants = /obj/item/clothing/under/roguetown/tights/black
//	shirt = /obj/item/clothing/suit/roguetown/shirt/vampire
//	belt = /obj/item/storage/belt/rogue/leather/plaquegold
//	head  = /obj/item/clothing/head/roguetown/vampire
//	beltl = /obj/item/key/vampire
//	cloak = /obj/item/clothing/cloak/cape/puritan
//	shoes = /obj/item/clothing/shoes/roguetown/armor
//	backl = /obj/item/storage/backpack/rogue/satchel/black
	owner.current.ambushable = FALSE
	owner.unknow_all_people()
	for(var/datum/mind/MF in get_minds("Succubi"))
		owner.i_know_person(MF)
		owner.person_knows_me(MF)

	var/mob/living/carbon/human/H = owner.current
//	var/obj/item/organ/eyes/eyes = owner.current.getorganslot(ORGAN_SLOT_EYES)
//	if(eyes)
//		eyes.Remove(owner.current,1)
//		QDEL_NULL(eyes)
//	eyes = new /obj/item/organ/eyes/night_vision/zombie
//	eyes.Insert(owner.current)
	//succ_look()
	H.equipOutfit(/datum/outfit/job/roguetown/succubus)
	H.set_patron(/datum/patron/inhumen/baotha)

	return TRUE
// for enchanted, when i make them
/datum/antagonist/succubus/proc/equip_spawn()
	owner.unknow_all_people()
	for(var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)
	for(var/datum/mind/MF in get_minds("Succubi"))
		owner.i_know_person(MF)
		owner.person_knows_me(MF)

	owner.adjust_skillrank(/datum/skill/magic/blood, 2, TRUE)
	owner.current.ambushable = FALSE

//leaving this here until i get around to adding gear
//mob/living/carbon/human/proc/spawn_pick_class()
//	var/list/classoptions = list(
//		/datum/subclass/hunter,
//		/datum/subclass/miner,
//		/datum/subclass/healer,
//		/datum/subclass/woodcutter,
//		/datum/subclass/blacksmith,
//		/datum/subclass/vampirerogue,
//		/datum/subclass/vampiremagos)
//	var/list/visoptions = list()
//
//	for(var/datum/subclass/A in SSrole_class_handler.sorted_class_categories[CTAG_ALLCLASS])
//		if(A.type in classoptions)
//			classoptions += A.name
//			classoptions -= A.type

//	for(var/T in 1 to 5) // leave as length(classoptions) for testing if you want all classes to show up.
//		if(length(classoptions))
	//		visoptions += pick_n_take(classoptions)

//	var/selected = input(src, "Which class was I?", "VAMPIRE SPAWN") as anything in visoptions

//	for(var/datum/subclass/A in SSrole_class_handler.sorted_class_categories[CTAG_ALLCLASS])
	//	if(A.name == selected)
	//		if(!A.outfit)
	//			to_chat(src, span_clown("Failed to equip chosen class, choose a new one."))
	//			log_message("ERROR: Unable to pick [A.name] as a subclass for [src].", LOG_GAME)
	//			spawn_pick_class()
	//			return

	//		if(equipOutfit(A.outfit))
	//			return

/datum/outfit/job/roguetown/succubus/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind.adjust_skillrank(/datum/skill/magic/blood, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
//	H.mind.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
//	H.mind.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
//	H.mind.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
//	H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
//	pants = /obj/item/clothing/under/roguetown/tights/black
//	shirt = /obj/item/clothing/suit/roguetown/shirt/vampire
//	belt = /obj/item/storage/belt/rogue/leather/plaquegold
//	head  = /obj/item/clothing/head/roguetown/vampire
//	beltl = /obj/item/key/vampire
//	cloak = /obj/item/clothing/cloak/cape/puritan
//	shoes = /obj/item/clothing/shoes/roguetown/armor
//	backl = /obj/item/storage/backpack/rogue/satchel/black
	H.ambushable = FALSE

////////Outfits////////
// not done yet!

/datum/antagonist/succubus/on_removal()
	if(!silent && owner.current)
		to_chat(owner.current,span_danger("I am no longer a [job_rank]!"))
	owner.special_role = null
	owner.current.possible_rmb_intents = initial(owner.current.possible_rmb_intents)
//	if(!isnull(batform))
	//	owner.current.RemoveSpell(batform)
	//	QDEL_NULL(batform)
	return ..()

datum/antagonist/succubus/proc/add_objective(datum/objective/O)
	var/datum/objective/V = new O
	objectives += V

datum/antagonist/succubus/proc/remove_objective(datum/objective/O)
	objectives -= O

datum/antagonist/succubus/proc/forge_succubus_objectives()
	//var/list/primary = pick(list("1", "2"))
	//var/list/secondary = pick(list("1", "2", "3"))

	return

/datum/antagonist/succubus/greet()
	to_chat(owner.current, span_userdanger("I am a beautiful creature, driven away long ago for my desire to spread pleasure. They have forgotten, now, but my body aches for the feeling of more essence, and to spread pleasure once more.."))
	owner.announce_objectives()
	..()

/datum/antagonist/succubus/proc/finalize_succubus()
	owner.current.forceMove(pick(GLOB.succubus_starts))
	owner.current.playsound_local(get_turf(owner.current), 'sound/music/vampintro.ogg', 80, FALSE, pressure_affected = FALSE)


/datum/antagonist/succubus/proc/succ_look()
	var/mob/living/carbon/human/V = owner.current
//	cache_skin = V.skin_tone
	var/obj/item/organ/eyes/eyes = V.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		cache_eyes = V.dna?.species.organs[ORGAN_SLOT_EYES]
		cache_eye_color = eyes.eye_color
		eyes.Remove(V)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(V)
	set_eye_color(V, cache_eye_color, cache_eye_color)
	eyes.update_accessory_colors()
	V.update_body()
	V.update_hair()
	V.update_body_parts(redraw = TRUE)
	V.faction = list("succubus")
	// Cycles through disguises to properly get eye color and other factions set.

//datum/antagonist/succubus/on_life(mob/user)

/datum/antagonist/succubus/proc/handle_vitae(change, tribute)
//	mypool.update_pool(change) // Spawn and Vlord now share a blood pool.
///	if(tribute)
//		mypool.update_pool(tribute)
	vitae += change
	if (vitae > vmax)
		vitae = vmax
	if(vitae <= 20)
		if(!starved)
			to_chat(owner, span_userdanger("I'm starving..I need essence..."))
			starved = TRUE
			for(var/S in MOBSTATS)
				owner.current.change_stat(S, -8)
	else
		if(starved)
			starved = FALSE
			for(var/S in MOBSTATS)
				owner.current.change_stat(S, 8)
//	vitae = mypool.current



/datum/antagonist/succubus/on_life(mob/user)
	if(!user)
		return
	var/mob/living/carbon/human/H = user
	if(H.stat == DEAD)
		return
	if(H.advsetup)
		return

	if(vitae > 0) // Being diguised drains vitae, other wise there is no vitae drain, allows vampires to relax and RP in the mansion.
		handle_vitae(-1)



/datum/antagonist/succubus/proc/move_to_spawnpoint()
	owner.current.forceMove(pick(GLOB.succubus_starts))




// eventually.
//datum/antagonist/enchanted
//	name = "Vampire Spawn"
//	antag_hud_name = "Vspawn"
//	confess_lines = list(
//		"THE CRIMSON CALLS!",
//		"MY MASTER COMMANDS",
//		"THE SUN IS ENEMY!",
//	)
//

// NEW VERBS
//mob/living/carbon/human/proc/demand_heart()
//	set name = "Demand Heart"
//	set category = "SUCCUBUS"
//	var/datum/game_mode/chaosmode/C = SSticker.mode
//	for(var/mob/living/carbon/human/H in oview(1))
//		if(SSticker.rulermob == H)
//			H.receive_heartdemand(src)

///mob/living/carbon/human/proc/receive_heartdemand(mob/living/carbon/human/lord)
//	if(stat)
//		return
//	switch(alert("Submit to [lord.name]'s beauty?",,"Yes","No"))
	//	if("Yes")
//
	//	if("No")
	//		lord << span_boldnotice("They refuse!")
//			src << span_boldnotice("I refuse!")

/mob/living/carbon/human/proc/succubus_telepathy()
	set name = "Telepathy"
	set category = "SUCCUBUS"
//	if(!is_not_staked(usr))
//		return
	var/datum/game_mode/chaosmode/C = SSticker.mode
	var/msg = input("Send a message.", "Command") as text|null
	if(!msg)
		return
	log_game("[key_name(src)] used succubus telepathy to say \"[msg]\"")
	for(var/datum/mind/V in C.succubi)
		to_chat(V, span_boldnotice("[src.real_name] speaks: \"[msg]\""))

//mob/living/carbon/human/proc/punish_spawn()
//	set name = "Punish Servant"
//	set category = "SUCCUBUS"
//	if(!is_not_staked(usr))
//		return
//	var/datum/game_mode/chaosmode/C = SSticker.mode
//	var/list/possible = list()
///	for(var/datum/mind/D in C.enchanted)
//		possible[D.current.real_name] = D.current
//	var/name_choice = input(src, "Who to punish?", "PUNISHMENT") as null|anything in possible
//	if(!name_choice)
//		return
//	var/mob/living/carbon/human/choice = possible[name_choice]
///	if(!choice || QDELETED(choice))
//		return
//	var/punishmentlevels = list("Pause", "Pain", "DESTROY")
//	var/punishment = input(src, "Severity?", "PUNISHMENT") as null|anything in punishmentlevels
//	if(!punishment)
//		return
//	switch(punishment)
//		if("Pain")
//			to_chat(choice, span_boldnotice("You are wracked with pain as your master punishes you!"))
//			choice.apply_damage(30, BRUTE)
//			choice.emote_scream()
	//		playsound(choice, 'sound/misc/obey.ogg', 100, FALSE, pressure_affected = FALSE)
//		if("Pause")
//			to_chat(choice, span_boldnotice("Your body is frozen in place as your master punishes you!"))
//			choice.Paralyze(300)
//			choice.emote_scream()
	//		playsound(choice, 'sound/misc/obey.ogg', 100, FALSE, pressure_affected = FALSE)
	//	if("DESTROY")
	//		to_chat(choice, span_boldnotice("You feel only darkness. Your master no longer has use of you."))
//			spawn(10 SECONDS)
//	//			choice.emote_scream()
//	visible_message(span_danger("[src] reaches out, gripping [choice]'s soul, inflicting punishment!"))

/* DISABLED FOR NOW
/obj/item/clothing/neck/roguetown/portalamulet/attack_self(mob/user)
	. = ..()
	if(alert(user, "Create a portal?", "PORTAL GEM", "Yes", "No") == "Yes")
		uses -= 1
		var/obj/effect/landmark/vteleportdestination/Vamp = new(loc)
		Vamp.amuletname = name
		for(var/obj/structure/vampire/portalmaker/P in GLOB.vampire_objects)
			P.create_portal_return(name, 3000)
		user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)
		if(uses <= 0)
			visible_message("[src] shatters!")
			qdel(src)
*/



/datum/antagonist/succubus/roundend_report()
	if(owner?.current)
		var/the_name = owner.name
		if(ishuman(owner.current))
			var/mob/living/carbon/human/H = owner.current
			the_name = H.real_name
		if(!totalessence)
			to_chat(world, "[the_name] was a succubus.")
		else
			to_chat(world, "[the_name] was a succubus. They stole [totalessence] essence from the people of Rockhill, and had [totalensnared] hearts in their grasp!")
	return

	var/traitorwin = TRUE

	var/count = 0
	if(objectives.len)//If the traitor had no objectives, don't need to process this.
		for(var/datum/objective/objective in objectives)
			objective.update_explanation_text()
			if(!objective.check_completion())
				traitorwin = FALSE
			count += objective.triumph_count

	if(!count)
		count = 1

	if(traitorwin)
		owner.adjust_triumphs(count)
		to_chat(owner.current, span_greentext("I've TRIUMPHED!"))
		if(owner.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_chat(owner.current, span_redtext("I've failed to sate baotha's will...."))
		if(owner.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)

// NEW OBJECTS/STRUCTURES

/obj/effect/landmark/start/succubus
	name = "Succubus"
	icon_state = "arrow"
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/succubus/Initialize()
	. = ..()
	GLOB.succubus_starts += loc
