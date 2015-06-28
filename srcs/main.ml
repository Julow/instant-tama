(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 19:52:57 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/28 19:49:10 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let handle_key data keysym =
	match keysym with
	| Sdlkey.KEY_1				-> Data.action data 0
	| Sdlkey.KEY_2				-> Data.action data 1
	| Sdlkey.KEY_3				-> Data.action data 2
	| Sdlkey.KEY_4				-> Data.action data 3
	| _							-> data

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
		| Sdlevent.KEYDOWN {Sdlevent.keysym = k}
				when k = Sdlkey.KEY_ESCAPE || k = Sdlkey.KEY_q		->
			Try.fail ()
		| Sdlevent.KEYDOWN
				{Sdlevent.keysym = k}								->
			handle_event ((handle_key data k), ui)
		| Sdlevent.QUIT												->
			Try.fail ()
		| _															->
			handle_event env
	else
		Try.return env


let rec gameoverloop (data, ui, prevtime) =
	match handle_event (data, ui) with
	| Try.Failure (_)			-> ()
	| Try.Success (data, ui)	->
	   let time = Sdltimer.get_ticks () in
	   (* let elapsed = time - prevtime in	    *)
	   gameoverloop (data, ui, time)
				   
let rec mainloop (data, ui, prevtime) =
	match handle_event (data, ui) with
	| Try.Failure (_)			-> ()
	| Try.Success (data, ui)	->
		let time = Sdltimer.get_ticks () in
		let elapsed = time - prevtime in
		let data = Data.decay_pikastat data elapsed in
		let data, ui = ui#update data elapsed in
		ui#draw (0, 0) data;
		Sdlvideo.flip (Data.display data);
		if Stat.any_depleted (Data.pikastats data) then begin
			let data = Data.set_pikadat data (Sprite.new_tmp_pika ~sid:19 200) in
			ui#draw (0, 0) data;
			Sdlvideo.flip (Data.display data);
			gameoverloop (data, ui, prevtime)
		  end
		else
		  mainloop (data, ui, time)

let is = Config.is
let ibs = Config.ibs
let iss = Config.iss
let ps = Config.pik_size
let bw = Config.bar_width
let bh = Config.bar_height

let init () =
	Sdl.init [`EVERYTHING];
	Sdlttf.init ();
	Sdlevent.enable_events Sdlevent.all_events_mask

let () =
	begin
		try init () with
		| exn					-> print_endline "Cannot init SDL"; ignore (exit 1)
	end;
	let data = Data.new_data (Config.w_width, Config.w_height) in
	mainloop (data, (new UI.group 0 0 Config.w_width Config.w_height [
		(new UI.sprite 0 0 301 331 1 :> UI.basic_object);
		(new UI.pika Config.pik_horiz_pos Config.pik_vert_pos ps ps 0);
		((new UI.gameover 50 100)#set_text "GAME OVER" (Data.font data) :> UI.basic_object);

		(new UI.group Config.icon_group_horizontal_pos
			Config.icon_group_vertical_pos
			Config.icon_group_width ibs
			[
				(new UI.button 0 0 ibs ibs 0 6);
				(new UI.button Config.icon2_delta 0 ibs ibs 1 2);
				(new UI.button Config.icon3_delta 0 ibs ibs 2 5);
				(new UI.button Config.icon4_delta 0 ibs ibs 3 4);
			]
		);
		(new UI.group
			(Config.bar_group_horiz_margin)
			(Config.bar_group_vert_margin) bw (bh * 2)
			[
				(* HPBAR *)
				(new UI.group 0 0 bw bh [
					(new UI.sprite 0 0 bw bh 10);
					(new UI.bar 0 0 bw bh 14 0);
				]);
				(* ENERGYBAR *)
				(new UI.group 0 bh bw bh [
					(new UI.sprite 0 0 bw bh 11);
					(new UI.bar 0 0 bw bh 14 1);
				]);
			]);
		(new UI.group
			(Config.w_width - Config.bar_group_horiz_margin - bw)
			(Config.bar_group_vert_margin) bw (bh * 2)
			[
			(* HYGYENEBAR *)
			(new UI.group 0 0 bw bh [
				(new UI.sprite 0 0 bw bh 12);
				(new UI.bar 0 0 bw bh 16 2);
			]);
			(* HAPPYNESSBAR *)
			(new UI.group 0 bh bw bh [
				(new UI.sprite 0 0 bw bh 13);
				(new UI.bar 0 0 bw bh 16 3);
			]);
		]);
	]), Sdltimer.get_ticks ())
