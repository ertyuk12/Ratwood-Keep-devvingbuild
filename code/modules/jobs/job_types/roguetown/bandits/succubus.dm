/datum/job/roguetown/succubus //pysdon above there's like THREE bandit.dms now I'm so sorry. This one is latejoin bandits, the one in villain is the antag datum, and the one in the 'antag' folder is an old refugee class we don't use. Good luck!
	title = "Succubus"
	flag = SUCCUBUS
	department_flag = FOREIGNERS
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	antag_job = TRUE
	allowed_races = RACES_VERY_SHUNNED_UP	//Begone foul seelies. Your age of banditry is gone
	tutorial = "I am a beautiful creature, driven away long ago for my desire to spread pleasure. They have forgotten, now, but my body aches for the feeling of more essence, and to spread pleasure once more.."

	outfit = null
	outfit_female = null

	display_order = JDO_SUCCUBUS
	show_in_credits = FALSE
	announce_latejoin = FALSE
	min_pq = null // for testing lol
	max_pq = null

//	subclass_cat_rolls = list(CTAG_BANDIT = 20)
	PQ_boost_divider = 10

	wanderer_examine = TRUE
	foreign_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE //no endless stream of bandits, unless the migration waves deem it so
	same_job_respawn_delay = 30 MINUTES


	cmode_music = 'sound/music/combat_bandit2.ogg'

/datum/job/roguetown/succubus/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(!H.mind)
			return
		//H.advsetup = 1
	//	H.invisibility = INVISIBILITY_MAXIMUM
	//	H.become_blind("advsetup")
		H.ambushable = FALSE
		var/datum/antagonist/new_antag = new /datum/antagonist/succubus()
		H.mind.add_antag_datum(new_antag)
	//	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "SUCCUBUS"), 5 SECONDS)

///datum/outfit/job/roguetown/bandit/post_equip(mob/living/carbon/human/H)
//	..()
///	var/datum/antagonist/new_antag = new /datum/antagonist/succubus()

//	if(!SSrole_class_handler.bandits_in_round)
//		SSrole_class_handler.bandits_in_round = TRUE
//	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "SUCCUBUS"), 5 SECONDS)