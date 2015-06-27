(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 19:52:57 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/27 19:52:58 by ngoguey          ###   ########.fr       *)
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
		ui#draw data;
		Sdlvideo.flip (Data.display data);
		mainloop (data, ui)

let () =
	Sdl.init [`EVERYTHING];
	Sdlttf.init ();
	Sdlevent.enable_events Sdlevent.all_events_mask;
	let data = Data.new_data (Config.w_width, Config.w_height) in
	mainloop (data, (new UI.group 0 0 Config.w_width Config.w_height [
		((new UI.text 50 50)#set_text "lolmdr" (Data.font data) :> UI.basic_object);
		(new UI.sprite 100 100 250 250 0);
	]))
