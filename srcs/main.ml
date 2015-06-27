(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 15:19:59 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/27 19:16:15 by jaguillo         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let show data =
	let sprite = Data.sprite_n data 0 in
	let iid = Sprite.iid sprite in
	let img = Data.image_n data iid in
	let d = Sdlvideo.display_format (Image.sdl_ptr img) in
	let dst = Data.display data in
	let rect = Sprite.rect sprite (Sprite.new_tmp sprite) in
	Sdlvideo.blit_surface ~src:d ~src_rect:rect ~dst:dst ();
	Sdlvideo.flip dst

let rec handle_event ((data, ui) as env) =
	if Sdlevent.has_event () then
		match Sdlevent.wait_event () with
		| Sdlevent.MOUSEBUTTONDOWN (e)								->
			handle_event ((ui#on_click e.mbe_x e.mbe_y data), ui)
		| Sdlevent.KEYDOWN (e) when e.keysym = Sdlkey.KEY_ESCAPE	->
			Try.fail ()
		| _															->
			handle_event env
	else
		Try.return data

let rec mainloop (data, ui) =
	match handle_event (data, ui) with
	| Try.Failure (_)			-> ()
	| Try.Success (data)		->
		show data;
		let ui = ui#update data in
		ui#draw data;
		mainloop (data, ui)

let () =
	Sdl.init [`EVERYTHING];
	Sdlttf.init ();
	Sdlevent.enable_events Sdlevent.all_events_mask;
	let data = Data.new_data (Config.w_width, Config.w_height) in
	mainloop (data, (new UI.group 0 0 Config.w_width Config.w_height [
		((new UI.text 50 50)#set_text "lolmdr" (Data.font data))
	]))
