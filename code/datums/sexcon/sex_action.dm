/datum/sex_action
	abstract_type = /datum/sex_action
	var/name = "Zodomize"
	/// Time to do the act, modified by up to 2.5x speed by the speed toggle
	var/do_time = 3.3 SECONDS
	/// Whether the act is continous and will be done on repeat
	var/continous = TRUE
	/// Stamina cost per action, modified by up to 2.5x cost by the force toggle
	var/stamina_cost = 0.5
	/// Whether the action requires both participants to be on the same tile
	var/check_same_tile = TRUE
	/// Whether the same tile check can be bypassed by an aggro grab on the person
	var/aggro_grab_instead_same_tile = TRUE
	/// Whether the action is forbidden from being done while incapacitated (stun, handcuffed)
	var/check_incapacitated = TRUE
	/// Whether the action requires an aggressive grab on the victim
	var/require_grab = FALSE
	/// If a grab is required, this is the required state of it
	var/required_grab_state = GRAB_AGGRESSIVE
	/// Vrell - used for determining if the user/target should be gagged
	var/gags_user = FALSE
	var/gags_target = FALSE

/datum/sex_action/proc/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return TRUE

/datum/sex_action/proc/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(gags_user)
		user.mouth_blocked = TRUE
	if(gags_target)
		target.mouth_blocked = TRUE

/datum/sex_action/proc/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return

/datum/sex_action/proc/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(gags_user)
		user.mouth_blocked = FALSE
	if(gags_target)
		target.mouth_blocked = FALSE

/datum/sex_action/proc/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return FALSE

/datum/sex_action/proc/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return TRUE


//add this to any sex actions you want the succubus to be able to steal essence from

/datum/sex_action/proc/try_succubus_drain(mob/living/carbon/human/succ, mob/living/carbon/human/victim)
	var/mob/living/carbon/human/drainer
	var/mob/living/carbon/human/drained
	var/truedrain = FALSE
	if(HAS_TRAIT(succ, TRAIT_SUCCUBUS) && !HAS_TRAIT(victim, TRAIT_SUCCUBUS))
		drainer = succ
		drained = victim
		truedrain = TRUE
	if(!HAS_TRAIT(succ, TRAIT_SUCCUBUS) && HAS_TRAIT(victim, TRAIT_SUCCUBUS))
		drainer = victim
		drained = succ
		truedrain = TRUE
	if (drained && drainer && truedrain)
		var/datum/antagonist/succubus/SD = drainer.mind.has_antag_datum(/datum/antagonist/succubus)
		if (!SD)
			return
		to_chat(drainer, span_love("My victim surrenders [(victim.gender == FEMALE) ? "her" : "his"] essence to me..It feels good!"))
		if (drained.STASTR > 5 && drainer.STASTR < 15) // sorry bucko, you aren't becoming a omnipotent horny entity
			drained.change_stat("strength", -2)
			if (!SD.starved) //prevents exploiting by starving to gain extra stats. Also, kinda makes sense, it's hard to steal more strength when you lack your own!
				drainer.change_stat("strength", 1)
		else
			drained.apply_damage(10, TOX)
		if (drained.STACON > 5  && drainer.STACON < 15)
			drained.change_stat("constitution", -2)
			if (!SD.starved)
				drainer.change_stat("constitution", 1)
		else
			drained.apply_damage(10, TOX)

		if (drained.STAINT > 5 && drainer.STAINT < 15)
			drained.change_stat("intelligence", -2)
			if (!SD.starved)
				drainer.change_stat("intelligence", 1)
		else
			drained.apply_damage(10, TOX)
		if (drained.STAEND > 5 && drainer.STAEND < 15)
			drained.change_stat("endurance", -2)
			if (!SD.starved)
				drainer.change_stat("endurance", 1)
		else
			drained.apply_damage(10, TOX)

		SD.handle_vitae(150) // enough for one heal
		if (!drained.has_status_effect(/datum/status_effect/debuff/succuhate) && !drained.has_status_effect(/datum/status_effect/buff/succulove))
			SD.handle_vitae(50)
			to_chat(drainer, span_love("Fresh essence! It tastes wonderful!"))
			SD.totalensnared += 1
		to_chat(drained, span_love("That felt so good...I'll need more soon.."))
		drained.apply_status_effect(/datum/status_effect/buff/succulove)
		drained.sexcon.adjust_charge(300)
		drainer.sexcon.adjust_charge(300) // infinite cum for the cum god
		if (drained.has_status_effect(/datum/status_effect/debuff/succuhate))
			drained.remove_status_effect(/datum/status_effect/debuff/succuhate)
		if (drained.has_status_effect(/datum/status_effect/debuff/succucharm))
			drained.remove_status_effect(/datum/status_effect/debuff/succucharm)

/datum/sex_action/proc/try_succubus_charm(mob/living/carbon/human/succ, mob/living/carbon/human/victim)
	var/mob/living/carbon/human/drainer
	var/mob/living/carbon/human/drained
	if(HAS_TRAIT(succ, TRAIT_SUCCUBUS) && !HAS_TRAIT(victim, TRAIT_SUCCUBUS))
		drainer = succ
		drained = victim
	//	truedrain = TRUE
	if(!HAS_TRAIT(succ, TRAIT_SUCCUBUS) && HAS_TRAIT(victim, TRAIT_SUCCUBUS))
		drainer = victim
		drained = succ
	if (drained && drainer && !drained.has_status_effect(/datum/status_effect/debuff/succuhate) && !drained.has_status_effect(/datum/status_effect/buff/succulove) && !drained.has_status_effect(/datum/status_effect/debuff/succucharm))
		to_chat(drainer, span_love("[drained.name] lusts for my body, now."))
		if (drained.patron.type == /datum/patron/divine/eora)
			to_chat(drained, span_love("I feel drawn to please myself on [drainer.name]..Is this normal..?"))
		else if (drained.patron.type == /datum/patron/inhumen/baotha)
			to_chat(drained, span_love("How wonderful, to be tempted by a fellow Baotha devoted like [drainer.name].."))
		else
			to_chat(drained, span_love("[drainer.name] is so beautiful..I must have more.."))
			drained.apply_status_effect(/datum/status_effect/debuff/succucharm)
		drained.sexcon.adjust_charge(300)
		drainer.sexcon.adjust_charge(300) // infinite cum for the cum god