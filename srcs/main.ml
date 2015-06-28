(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 19:52:57 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/28 15:38:41 by jaguillo         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let rec handle_event ((data, ui) as env) =
	if Sdlevent.has_event () then
		match Sdlevent.wait_event () with
		| Sdlevent.MOUSEBUTTONDOWN (e)								->
			let x = e.mbe_x in
			let y = e.mbe_y in
			let ui = ui#_on_event x y true true in
			handle_event ((ui#on_click x y data), ui)
		| Sdlevent.MOUSEBUTTONUP (e)								->
			handle_event (data, (ui#_on_event e.mbe_x e.mbe_y false false))
		| Sdlevent.MOUSEMOTION (e)									->
			handle_event (data, (ui#_on_event e.mme_x e.mme_y false true))
		| Sdlevent.KEYDOWN (e) when e.keysym = Sdlkey.KEY_ESCAPE	->
			Try.fail ()
		| Sdlevent.QUIT												->
			Try.fail ()
		| _															->
			handle_event env
	else
		Try.return env

let rec mainloop (data, ui) =
	match handle_event (data, ui) with
	| Try.Failure (_)			-> ()
	| Try.Success (data, ui)	->
		let ui = ui#update data in
		ui#draw (0, 0) data;
		Sdlvideo.flip (Data.display data);
		mainloop (data, ui)

let is = Config.is
let ibs = Config.ibs
let iss = Config.iss
let ps = Config.pik_size
			
let () =
Printf.printf "is%d  ibs%d  iss%d\n%!" is ibs iss;
Sdl.init [`EVERYTHING];
	Sdlttf.init ();
	Sdlevent.enable_events Sdlevent.all_events_mask;
	let data = Data.new_data (Config.w_width, Config.w_height) in
	mainloop (data, (new UI.group 0 0 Config.w_width Config.w_height [
		(new UI.sprite 0 0 301 331 1 :> UI.basic_object);
 		((new UI.text 50 50)#set_text "lolmdr" (Data.font data) :> UI.basic_object);
		(new UI.sprite Config.pik_horiz_pos Config.pik_vert_pos ps ps 0);

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
		)
		  
	]))
