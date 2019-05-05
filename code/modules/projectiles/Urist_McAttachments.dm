//Holder file for all the vars, and hopefully procs regarding the Attachment system that is certainly not completely ripped off from CM. I promise. I only looked at the code once.
//Scribbles of a madman to follow.

#define MUZZLE 1
#define RAIL 2
#define UNDER 3
#define STOCK 4




/obj/item/weapon/gun
	var/attachable_overlays[] 		= null		//List of overlays so we can switch them in an out, instead of using Cut() on overlays.
	var/attachable_offset[] 		= null		//List.Every two indeces is an x/y coordinate for an attachment. FROM THE CENTER OF THE SPRITE. Check example icon in attachments.dmi
	var/attachable_allowed[]		= null		//Must be the exact path to the attachment present in the list. Leave null if there are no restrictions.
	var/obj/item/attachment/muzzle 	= null		//Attachable slots. Only one item per slot.
	var/obj/item/attachment/rail 	= null
	var/obj/item/attachment/under 	= null
	var/obj/item/attachment/stock 	= null
	var/obj/item/attachment/attached_gun/active_attachable = null //This will link to one of the above four, or remain null. Probably yeeting this unless I feel like fixing the advanced SMG UGL.
	var/list/starting_attachments = null //What attachments this gun starts with. Used as a list of exact paths.)

//Stat related shit.
	var/accuracy_mult 			= 0				//Multiplier. Increased and decreased through attachments. Multiplies the projectile's accuracy by this number.
	var/damage_mult 			= 1				//Same as above, for damage.



/obj/item/weapon/gun/Initialize() // I totes tested this, since the file is lower in the hierarchy, it just adds to the existing initialization.
	. = ..()
	if(starting_attachments && starting_attachments.len)
		for(var/i in starting_attachments)
			var/obj/item/attachment/A = new i(src)
			A.Attach(src)


/obj/item/weapon/gun/attackby(user, var/obj/item/attachment/A)
	if(!istype(A, obj/item/attachment/

/obj/item/weapon/gun/proc/add_attachment(user, var/obj/item/attachment/A) // Newspawn dictates if it should skip all the player interactivity crap. Index just tells it what to pull from the starting list..

	if( do_after(user, 1 SECOND, can_move = TRUE) )
		A.Attach(src)



/obj/item/weapon/gun/proc/remove_attachment(user)
	//Alert for what you want to remove.
	switch( alert("From whichslot do you want to remove?",,"Muzzle","Rail","Underbarrel","Stock") )
		if("Muzzle")
			muzzle.Detach()
		if("Rail")
			rail.Detach()
		if("Underbarrel")
			under.Detach()
		if("Stock")
			stock.Detach()

/obj/item/weapon/gun/proc/update_attachment_image()


/* ---------------------------------BIG LONG READABILITY DIVIDING LINE---------------------------------*/

obj/item/attachment //Attachment base object. Carries variables.
	name = "shitcode attachment"
	desc = "You really shouldn't see this. Complain at the staffmember that spawned this for you, or the last coder to edit Urist_McAttachments.dm, in that order." //Maybe a bit sassy, but informative.

	var/position //basically just a way to switch_statement-ify these things. 1-4,

	var/burst_mod // How many do we shoot?
	var/burst_accuracy_mod //
	var/recoil_mod //dictates screen shake
	var/accuracy_mod //Every whole number counts as that many turfs closer. Can be negative.
	var/delay_mod // Affects postfire delay.
	var/burst_delay_mod //Affects burst speed.
	var/force_mod//edits force
	var/list/force_type = list() //List. Index 1 is edge, index 2 is sharp. Booleans.
	var/suppressor

//Vars that specifically fuck with the projectile
	var/damage_mod //is it possible, even?
	var/damage_type_mod //Lets us change what kind of damage the projectile will do!


obj/item/attachment/proc/Attach(obj/item/weapon/gun/G) // Only slightly completely stolen from CM. Unfortunately no real other way to do this.
	if(!istype(G))
		return

	switch(position)
		if(RAIL) 		G.rail = src//If it's being called on by this proc, it has to be that attachment. ~N
		if(MUZZLE) 	G.muzzle = src
		if(UNDER)		G.under = src
		if(STOCK)		G.stock = src



	G.accuracy_mult		+= accuracy_mod
	G.damage_mult		+= damage_mod
	G.fire_delay 		+= delay_mod
	G.burst_delay 		+= burst_delay_mod
	G.burst 			+= burst_mod
	G.screen_shake		+= recoil_mod
	G.force 			+= force_mod
	G.edge 				+= force_type[1]
	G.sharp 			+= force_type[2]

	if(suppressor) //Built in silencers always come as an attach, so the gun can't be silenced right off the bat.
		G.silenced = TRUE
	forceMove(G)
	G.update_attachment_image()


obj/item/attachment/proc/Detach(obj/item/weapon/gun/G) //Inverse of the above.
	if(!istype(G))
		return

	switch(position)
		if(RAIL)
			G.rail = null
		if(MUZZLE)
			G.muzzle = null
		if(UNDER)
			G.under = null
		if(STOCK)
			G.stock = null



	G.accuracy_mult		-= accuracy_mod
	G.damage_mult		-= damage_mod
	G.fire_delay 		-= delay_mod
	G.burst_delay 		-= burst_delay_mod
	G.burst 		-= burst_mod
	G.screen_shake		-= recoil_mod
	G.force 			-= force_mod
	G.edge 				-= force_type[1]
	G.sharp 			-= force_type[2]

	if(suppressor) //Built in silencers always come as an attach, so the gun can't be silenced right off the bat.
		G.silenced = TRUE
	forceMove(get_turf(src))
	G.update_attachment_image()

obj/item/attachment/muzzle
	name = "shitcode muzzle"
	position = MUZZLE

obj/item/attachment/rail
	name = "shitcode rail"
	position = RAIL

obj/item/attachment/under
	name = "shitcode underbarrel"
	position = UNDER

obj/item/attachment/stock
	name = "shitcode stock"
	position = STOCK