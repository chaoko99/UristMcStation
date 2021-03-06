/mob/living/simple_animal/hostile/npc/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(speech_triggers.len)
		if(speaker in view(7, src))
			for(var/datum/npc_speech_trigger/T in speech_triggers)
				if(T.trigger_phrase)
					if(message == T.trigger_phrase)
						do_react(T)
				else if(T.trigger_words)
					for(var/triggerword in T.trigger_words)
						if(findtext(message,triggerword))
							do_react(T)

/mob/living/simple_animal/hostile/npc/proc/do_react(var/datum/npc_speech_trigger/T)
	if(prob(T.response_chance))
		if(!angryspeak)
			if(T.response_phrase)
				var/resp_phrase = T.get_response_phrase()
				var/speech_bubble_test = say_test(resp_phrase)
				var/msg = "<span class='game say'><span class='name'>[src.name]</span> says, <span class='message'><span class='body'>\"[resp_phrase]\"</span></span></span>"
				src.audible_message(msg)
				var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h[speech_bubble_test]")
				for(var/mob/M in view(7, src))
					to_chat(M, speech_bubble)
				spawn(30) qdel(speech_bubble)

		else
			if(T.angryresponse_phrase)
				var/resp_phrase = T.get_angryresponse_phrase()
				var/speech_bubble_test = say_test(resp_phrase)
				var/msg = "<span class='game say'><span class='name'>[src.name]</span> says, <span class='message'><span class='body'>\"[resp_phrase]\"</span></span></span>"
				src.audible_message(msg)
				var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h[speech_bubble_test]")
				for(var/mob/M in view(7, src))
					to_chat(M, speech_bubble)
				spawn(30) qdel(speech_bubble)

			else if(T.response_phrase)
				var/resp_phrase = T.get_response_phrase()
				var/speech_bubble_test = say_test(resp_phrase)
				var/msg = "<span class='game say'><span class='name'>[src.name]</span> says, <span class='message'><span class='body'>\"[resp_phrase]\"</span></span></span>"
				src.audible_message(msg)
				var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h[speech_bubble_test]")
				for(var/mob/M in view(7, src))
					to_chat(M, speech_bubble)
				spawn(30) qdel(speech_bubble)


