(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 19:52:57 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/28 16:07:29 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let rec handle_event ((data, ui) as env) =
	if Sdlevent.has_event () then
		match Sdlevent.wait_event () with
		| Sdlevent.MOUSEBUTTONDOWN
				{Sdlevent.mbe_x = x ; Sdlevent.mbe_y = y}			->
			let ui = ui#_on_event x y true true in
			handle_event ((ui#on_click x y data), ui)
		| Sdlevent.MOUSEBUTTONUP
				{Sdlevent.mbe_x = x ; Sdlevent.mbe_y = y}			->
			handle_event (data, (ui#_on_event x y false false))
		| Sdlevent.MOUSEMOTION
				{Sdlevent.mme_x = x ; Sdlevent.mme_y = y}			->
			handle_event (data, (ui#_on_event x y false true))
		| Sdlevent.KEYDOWN
				{Sdlevent.keysym = k} when k = Sdlkey.KEY_ESCAPE	->
			Try.fail ()
		| Sdlevent.QUIT												->
			Try.fail ()
		| _															->
			handle_event env
	else
		Try.return env

let rec mainloop (data, ui, prevtime) =
	match handle_event (data, ui) with
	| Try.Failure (_)			-> ()
	| Try.Success (data, ui)	->
		let time = Sdltimer.get_ticks () in
		let elapsed = prevtime - time in
		let ui = ui#update data elapsed in
		ui#draw (0, 0) data;
		Sdlvideo.flip (Data.display data);
		mainloop (data, ui, time)

let is = Config.is
let ibs = Config.ibs
let iss = Config.iss
let ps = Config.pik_size
let bw = Config.bar_width
let bh = Config.bar_height
		   
let () =
	Sdl.init [`EVERYTHING];
	Sdlttf.init ();
	Sdlevent.enable_events Sdlevent.all_events_mask;
	let data = Data.new_data (Config.w_width, Config.w_height) in
	mainloop (data, (new UI.group 0 0 Config.w_width Config.w_height [
		(new UI.sprite 0 0 301 331 1 :> UI.basic_object);
 		((new UI.text 50 350)#set_text "lolmdr" (Data.font data) :> UI.basic_object);
		(new UI.pika Config.pik_horiz_pos Config.pik_vert_pos ps ps 0);

		(new UI.group Config.icon_group_horizontal_pos
			 Config.icon_group_vertical_pos
			 Config.icon_group_width ibs
			 [
			   (new UI.group 0 0 ibs ibs [
					  (new UI.sprite iss iss is is 2);
					  (new UI.sprite 0 0 ibs ibs 3);
					]);
			   (new UI.group Config.icon2_delta 0 ibs ibs [
					  (new UI.sprite iss iss is is 4);
					  (new UI.sprite 0 0 ibs ibs 3);
					]);
			   (new UI.group Config.icon3_delta 0 ibs ibs [
					  (new UI.sprite iss iss is is 5);
					  (new UI.sprite 0 0 ibs ibs 3);
					]);
			   (new UI.group Config.icon4_delta 0 ibs ibs [
					  (new UI.sprite iss iss is is 6);
					  (new UI.sprite 0 0 ibs ibs 3);
					]);
			 ]
		);
		(new UI.group
			 (Config.bar_group_horiz_margin)
			 (Config.bar_group_vert_margin) bw (bh * 2)
			   [
				 (* HPBAR *)
			   (new UI.group 0 0 bw bh [
					  (new UI.sprite 0 0 bw bh 10);
					  (new UI.sprite 0 0 bw bh 14);					  
					]);
			   (* ENERGYBAR *)
			   (new UI.group 0 bh bw bh [
					  (new UI.sprite 0 0 bw bh 11);
					  (new UI.sprite 0 0 bw bh 14);					  
					]);
			   ]);
		  (new UI.group
			 (Config.w_width - Config.bar_group_horiz_margin - bw)
			 (Config.bar_group_vert_margin) bw (bh * 2)
			   [
				 (* HYGYENEBAR *)
			   (new UI.group 0 0 bw bh [
					  (new UI.sprite 0 0 bw bh 12);
					  (new UI.sprite 0 0 bw bh 16);					  
					]);
			   (* HAPPYNESSBAR *)
			   (new UI.group 0 bh bw bh [
					  (new UI.sprite 0 0 bw bh 13);
					  (new UI.sprite 0 0 bw bh 16);					  
					]);
			   ]);
			   
	]), Sdltimer.get_ticks ())
