(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 19:52:57 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/28 12:58:46 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let rec handle_event ((data, ui) as env) =
	if Sdlevent.has_event () then
		match Sdlevent.wait_event () with
		| Sdlevent.MOUSEBUTTONDOWN (e)								->
			handle_event ((ui#on_click e.mbe_x e.mbe_y data), ui)
		| Sdlevent.KEYDOWN (e) when e.keysym = Sdlkey.KEY_ESCAPE	->
			Try.fail ()
		| Sdlevent.QUIT												->
			Try.fail ()
		| _															->
			handle_event env
	else
		Try.return data

let rec mainloop (data, ui) =
	match handle_event (data, ui) with
	| Try.Failure (_)			-> ()
	| Try.Success (data)		->
		let ui = ui#update data in
		ui#draw (0, 0) data;
		Sdlvideo.flip (Data.display data);
		mainloop (data, ui)

let () =
	Sdl.init [`EVERYTHING];
	Sdlttf.init ();
	Sdlevent.enable_events Sdlevent.all_events_mask;
	let data = Data.new_data (Config.w_width, Config.w_height) in
	mainloop (data, (new UI.group 0 0 Config.w_width Config.w_height [
		(new UI.sprite 0 0 301 331 1 :> UI.basic_object);
 		((new UI.text 50 50)#set_text "lolmdr" (Data.font data) :> UI.basic_object);
		(new UI.sprite 10 10 250 250 0);

		(new UI.group 100 400 (92 * 4) 92
			 [
			   (new UI.group 0 0 92 92 [
					  (new UI.sprite 15 15 64 64 2);
					  (new UI.sprite 0 0 92 92 3);
					]);
			   (new UI.group 92 0 92 92 [
					  (new UI.sprite 15 15 64 64 4);
					  (new UI.sprite 0 0 92 92 3);
					]);
			   (new UI.group 184 0 92 92 [
					  (new UI.sprite 15 15 64 64 5);
					  (new UI.sprite 0 0 92 92 3);
					]);
			   (new UI.group 276 0 92 92 [
					  (new UI.sprite 15 15 64 64 6);
					  (new UI.sprite 0 0 92 92 3);
					]);
			 ]
		)
		  
	]))
			 
