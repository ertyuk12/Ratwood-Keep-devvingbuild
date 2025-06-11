/obj/effect/proc_holder/spell/targeted/transfixsucc
	name = "Seductive Charm"
	overlay_state = "transfix"
	releasedrain = 100
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/blood
	antimagic_allowed = TRUE
	charge_max = 10 SECONDS
	include_user = 0
	max_targets = 1 //There's supposed to be a threesome joke here, but the game broke when i edited this :( (it's still broken)
	var/wild_patrons = list(/datum/patron/divine/dendor, //patrons that will pounce on the succubus
	/datum/patron/inhumen/graggar
	)
	var/sub_patrons = list( //patrons that will submissively throw themselves to the ground (when transfix actually works)
		/datum/patron/divine/eora, /datum/patron/inhumen/baotha
	)
/obj/effect/proc_holder/spell/targeted/transfixsucc/cast(list/targets, mob/user = usr)
	var/msg = input("A heart to take, I simply must convince them to give it up..", "Transfix") as text|null
	if(length(msg) < 10)
		to_chat(user, span_userdanger("This is not enough!"))
		return FALSE
	var/bloodskill = user.mind.get_skill_level(/datum/skill/magic/blood)
	var/bloodroll = roll("[bloodskill]d8")
	user.say(msg)
	for(var/mob/living/carbon/human/L in targets)
		var/datum/antagonist/succubus/VD = L.mind.has_antag_datum(/datum/antagonist/succubus)
		var/willpower = round(L.STAINT / 4)
		var/willroll = roll("[willpower]d6")
		if(VD)
			return
		if(L.cmode)
			willroll += 10
		var/found_psycross = FALSE
		for(var/obj/item/clothing/neck/roguetown/psicross/silver/I in L.contents) //Subpath fix.
			found_psycross = TRUE
			break

		if(bloodroll >= willroll)
			if(found_psycross == TRUE)
				to_chat(L, "<font color='white'>The silver psycross shines and protect me from the unholy magic.</font>")
				to_chat(user, span_userdanger("[L] has my BANE! It causes me to fail to ensnare their mind!"))
			else
				L.drowsyness = min(L.drowsyness + 50, 150)
				switch(L.drowsyness)
					if(0 to 50)
						to_chat(L, "A purple haze begins to fill your wits...")
						to_chat(user, "Their mind gives way slightly.")
						L.Slowdown(20)
						if (L.sexcon)
							L.sexcon.arousal += 15

					if(50 to 100)
						to_chat(L, "Your body begins to ache..Has your clothing always been this hot?")
						L.Slowdown(50)
						to_chat(user, "They will not be able to resist much more.")
						visible_message(span_danger("[L.name]'s arms stray down to [(L.gender == FEMALE) ? "her" : "his"] groin..."))
						if (L.sexcon)
							L.sexcon.arousal += 15
					if(100 to INFINITY)
						to_chat(L, span_userdanger("Your body aches too much, and you give in to the temptation."))
						to_chat(user, "They want me, now!")

						L.Paralyze(30)
						if (L.patron.type in sub_patrons)
							L.Knockdown(30)
							visible_message(span_lovebold("[L.name] strips [(L.gender == FEMALE) ? "her" : "him"]self down, before throwing [(L.gender == FEMALE) ? "her" : "him"]self to the ground, [(L.gender == FEMALE) ? "her" : "his"]'s gaze lustfully anchored to [user.name]!"))

		if(willroll >= bloodroll)
			if(found_psycross == TRUE)
				to_chat(L, "<font color='white'>The silver psycross shines and protect me from the unholy magic.</font>")
				to_chat(user, span_userdanger("[L] has my BANE! It causes me to fail to ensnare their mind!"))
			else
				to_chat(user, "I fail to ensnare their mind.")
			if(willroll - bloodroll >= 3)
				if(found_psycross == TRUE)
					to_chat(L, "<font color='white'> The silver psycross shines and protect me from the baothan magic, the one who used baothan magic was [user]!</font>")
				else
					to_chat(user, "I fail to ensnare their mind.")
					to_chat(L, "I feel like someone or something unholy is messing with my head. I should get out of here!")

/obj/effect/proc_holder/spell/targeted/succ_rejuv
	name = "Rejuvenate"
	desc = "Regenerates my targeted limb and Replenishes half my stamina. Recharges every 30 seconds. I must stand still."
	overlay_state = "doc"
	action_icon = 'icons/mob/actions/roguespells.dmi'
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	range = -1
	warnie = "sydwarning"
	movement_interrupt = TRUE
	chargedloop = null
	invocation_type = "whisper"
	associated_skill = /datum/skill/magic/blood
	antimagic_allowed = FALSE
	charge_max = 1 MINUTES
	cooldown_min = 30 SECONDS
	include_user = TRUE
	max_targets = 1
	vitaedrain = 100

/obj/effect/proc_holder/spell/targeted/succ_rejuv/cast(list/targets, mob/user = usr)
	if(user && iscarbon(user))
		var/mob/living/carbon/succ = user
		var/datum/antagonist/succubus/VD = user.mind.has_antag_datum(/datum/antagonist/succubus)
		var/bloodskill = succ.mind.get_skill_level(/datum/skill/magic/blood)
		if ((VD.vitae - 150) < 0)
			to_chat(succ, span_redtext("I'm too hungry to recover..."))
			return
	//	var/bloodskill = succ.mind.get_skill_level(/datum/skill/magic/blood)
		VD.handle_vitae(-150)
		// How much the vampire will heal by.
		var/bloodroll = (roll("[bloodskill]d8") + (succ.STACON * 1.5)) * 2
		succ.heal_overall_damage(bloodroll, bloodroll)
		succ.adjustToxLoss(-bloodroll * 10) // Purges toxins.
		succ.adjustOxyLoss(-bloodroll)
		succ.heal_wounds(bloodroll * 30)
		succ.blood_volume += BLOOD_VOLUME_SURVIVE
		succ.update_damage_overlays()
		to_chat(succ, span_greentext("! REJUVENATE AMT: [bloodroll] !"))
		succ.visible_message(span_danger("[succ] glows in a dim, purple aura as their wounds close!"))
		succ.playsound_local(get_turf(succ), 'sound/misc/vampirespell.ogg', 100, FALSE, pressure_affected = FALSE)
