// Structures

/obj/effect/weaversilk
	name = "weaversilk web"
	desc = "A thin layer of fiberous webs. It looks like it can be torn down with one strong hit."
	icon = 'icons/vore/weaver_icons_vr.dmi'
	anchored = TRUE
	density = FALSE

/obj/effect/weaversilk/ex_act(severity)
	qdel(src)
	return

/obj/effect/weaversilk/attackby(var/obj/item/weapon/W, var/mob/user)
	user.setClickCooldown(user.get_attack_speed(W))

	if(W.force)
		visible_message("<span class='warning'>\The [src] has been [LAZYLEN(W.attack_verb) ? pick(W.attack_verb) : "attacked"] with \the [W][(user ? " by [user]." : ".")]</span>")
		qdel(src)

/obj/effect/weaversilk/bullet_act(var/obj/item/projectile/Proj)
	..()
	if(Proj.get_structure_damage())
		qdel(src)

/obj/effect/weaversilk/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	qdel(src)

/obj/effect/weaversilk/attack_generic(mob/user as mob, var/damage)
	if(damage)
		qdel(src)

/obj/effect/weaversilk/attack_hand(mob/user as mob)
	..()
	if(user.a_intent == I_HURT)
		to_chat(user,"<span class='warning'>You easily tear down [name].</span>")
		qdel(src)

/obj/effect/weaversilk/floor
	var/possible_icon_states = list("floorweb1", "floorweb2", "floorweb3", "floorweb4", "floorweb5", "floorweb6", "floorweb7", "floorweb8")
	plane = DIRTY_PLANE
	layer = DIRTY_LAYER

/obj/effect/weaversilk/floor/Initialize()
	..()
	icon_state = pick(possible_icon_states)

/obj/effect/weaversilk/wall
	name = "weaversilk web wall"
	desc = "A thin layer of fiberous webs, but just thick enough to block your way. It looks like it can be torn down with one strong hit."
	icon_state = "wallweb1"
	var/possible_icon_states = list("wallweb1", "wallweb2", "wallweb3")
	density = TRUE

/obj/effect/weaversilk/wall/Initialize()
	..()
	icon_state = pick(possible_icon_states)

/obj/effect/weaversilk/wall/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mover
		if(H.species.is_weaver)
			return TRUE
	..()

/obj/structure/bed/double/weaversilk_nest
	name = "weaversilk nest"
	desc = "A nest of some kind, made of fiberous material."
	icon = 'icons/vore/weaver_icons_vr.dmi'
	icon_state = "nest"
	base_icon = "nest"

/obj/structure/bed/double/weaversilk_nest/update_icon()
	return

/obj/structure/bed/double/weaversilk_nest/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.is_wrench() || istype(W,/obj/item/stack) || W.is_wirecutter())
		return
	..()

/obj/structure/bed/double/weaversilk_nest/attack_hand(mob/user as mob)
	..()
	if(user.a_intent == I_HURT && !has_buckled_mobs())
		to_chat(user,"<span class='warning'>You easily tear down [name].</span>")
		qdel(src)

/obj/effect/weaversilk/trap
	name = "weaversilk trap"
	desc = "A silky, yet firm trap. Be careful not to step into it! Or don't..."
	icon_state = "trap"
	var/trap_active = TRUE

/obj/effect/weaversilk/trap/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if(istype(AM, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if(H.species.is_weaver)
			return
	if(isliving(AM) && trap_active)
		var/mob/living/L = AM
		if(L.m_intent == "run")
			L.visible_message(
				"<span class='danger'>[L] steps on \the [src].</span>",
				"<span class='danger'>You step on \the [src]!</span>",
				"<b>You hear a squishy noise!</b>"
				)
			set_dir(L.dir)
			can_buckle = TRUE
			buckle_mob(L)
			L.Stun(1 SECOND) //YW EDIT
			to_chat(L, "<span class='danger'>The sticky fibers of \the [src] ensnare, trapping you in place!</span>")
			trap_active = FALSE
			can_buckle = initial(can_buckle)
			desc += " Actually, it looks like it's been all spent."
	..()



// Items

// TODO: Spidersilk clothing and actual bindings, once sprites are ready.

/obj/item/clothing/suit/straight_jacket/weaversilk_bindings //YW EDIT
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	name = "weaversilk bindings"
	desc = "A webbed cocoon that completely restrains the wearer."
	icon_state = "web_bindings"
	item_state = "web_bindings_mob"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER //YW EDIT
	//yw edit start - Teshari Sprite
	resist_time = 600	// 1.5 minutes
	slowdown = 1.5
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/vore/custom_onmob_yw.dmi'
		)

/obj/item/clothing/suit/straight_jacket/weaversilk_bindings/get_worn_icon_file(var/body_type,var/slot_name,var/default_icon,var/inhands)
	if(body_type == SPECIES_TESHARI)
		if(!inhands)
			return 'icons/vore/custom_onmob_yw.dmi'
	return ..()
//yw edit end