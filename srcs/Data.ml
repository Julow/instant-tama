(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Data.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 16:37:26 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/28 20:35:05 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type data = {
	winsize: (int * int);
	display: Sdlvideo.surface;
	sprites: Sprite.dat array;
	font: Sdlttf.font;
	pikadat: Sprite.tmpdatpika;
	pikastats: Stat.t;
	bgid: int
  }

let is = Config.is
let ibs = Config.ibs
let iss = Config.iss
let ps = Config.pik_size
let bw = Config.bar_width
let bh = Config.bar_height
		   
let new_data ((winx, winy) as winsize) =
  let display = Sdlvideo.set_video_mode winx winy [`DOUBLEBUF] in
  let images = [|
	  (Image.load_texture Config.icon_path 0);
	  (Image.load_texture Config.pikatchu_path 1);
	  (Image.load_texture Config.bg_path 2);
	  (Image.load_texture Config.iconborder_path 3);
	  (Image.load_texture Config.hpbar_path 4);
	  (Image.load_texture Config.manabar_path 5);
	  (Image.load_texture Config.hygbar_path 6);
	  (Image.load_texture Config.hapbar_path 7);
	  (Image.load_texture Config.fill1_path 8);
	  (Image.load_texture Config.fill2_path 9);
	  (Image.load_texture Config.fill3_path 10);
	  (Image.load_texture Config.iconalert 11);
	  (Image.load_texture Config.iconalertants 12);
	 |] in
  let sprites = [|
	  (* PIKACHU IDLE *)
	  (Sprite.new_sprite 0 1 (Image.sdl_ptr images.(1))
						 (0, 91) (58, 58) (15, 15) (ps, ps) 1000);
	  (* BACKGROUNDS *)
	  (Sprite.new_sprite 1 2 (Image.sdl_ptr images.(2))
						 (0, 0) (300, 331) (2, 2)
						 (Config.w_width, Config.w_height) 1000);
	  (* ICON1 *)
	  (Sprite.new_sprite 2 0 (Image.sdl_ptr images.(0))
						 (0, 0) (64, 64) (1, 1) (is, is) 1000);
	  (* ICON BORDER *)
	  (Sprite.new_sprite 3 3 (Image.sdl_ptr images.(3))
						 (0, 0) (72, 72) (1, 1) (ibs, ibs) 1000);
	  (* ICON2 *)
	  (Sprite.new_sprite 4 0 (Image.sdl_ptr images.(0))
						 (64, 0) (64, 64) (1, 1) (is, is) 1000);
	  (* ICON3 *)
	  (Sprite.new_sprite 5 0 (Image.sdl_ptr images.(0))
						 (128, 0) (64, 64) (1, 1) (is, is) 1000);
	  (* ICON4 *)
	  (Sprite.new_sprite 6 0 (Image.sdl_ptr images.(0))
						 (192, 0) (64, 64) (1, 1) (is, is) 1000);
	  (* PIKACHU THUNDER *)
	  (Sprite.new_sprite 7 1 (Image.sdl_ptr images.(1))
						 (4, 154) (59, 59) (12, 12) (ps, ps) 200);
	  (* PIKACHU KILL *)
	  (Sprite.new_sprite 8 1 (Image.sdl_ptr images.(1))
						 (217, 771) (70, 70) (8, 8) (ps, ps) 120);
	  (* PIKACHU BATH *)
	  (Sprite.new_sprite 9 1 (Image.sdl_ptr images.(1))
						 (0, 541) (68, 68) (7, 7) (ps, ps) 500);

	  (* BAR HP *)
	  (Sprite.new_sprite 10 4 (Image.sdl_ptr images.(4))
						 (0, 0) (256, 64) (1, 1) (bw, bh) 1000);
	  (* BAR MANA *)
	  (Sprite.new_sprite 11 5 (Image.sdl_ptr images.(5))
						 (0, 0) (256, 64) (1, 1) (bw, bh) 1000);
	  (* BAR HYGIENNE *)
	  (Sprite.new_sprite 12 6 (Image.sdl_ptr images.(6))
						 (0, 0) (256, 64) (1, 1) (bw, bh) 1000);
	  (* BAR HAPPYNESS *)
	  (Sprite.new_sprite 13 7 (Image.sdl_ptr images.(7))
						 (0, 0) (256, 64) (1, 1) (bw, bh) 1000);

	  (* FILL1 *)
	  (Sprite.new_sprite 14 8 (Image.sdl_ptr images.(8))
						 (0, 0) (256, 64) (1, 1) (bw, bh) 1000);
	  (* FILL2 *)
	  (Sprite.new_sprite 15 9 (Image.sdl_ptr images.(9))
						 (0, 0) (256, 64) (1, 1) (bw, bh) 1000);
	  (* FILL3 *)
	  (Sprite.new_sprite 16 10 (Image.sdl_ptr images.(10))
						 (0, 0) (256, 64) (1, 1) (bw, bh) 1000);
	  (* ICON HOVER *)
	  (Sprite.new_sprite 17 11 (Image.sdl_ptr images.(11))
						 (1, 69) (67, 68) (1, 1)
						 (Config.hover_size, Config.hover_size) 1000);
	  (* ICON ANTS *)
	  (Sprite.new_sprite 18 12 (Image.sdl_ptr images.(12))
						 (0, 0) (48, 48) (22, 5)
						 (Config.ant_size, Config.ant_size) 1000);
	  (* PIKACHU DEAD *)
	  (Sprite.new_sprite 19 1 (Image.sdl_ptr images.(1))
						 (339, 718) (61, 61) (1, 1) (ps, ps) 500);
	  
	  (* ICON BACKGROUNDS *)
	  (Sprite.new_sprite 20 2 (Image.sdl_ptr images.(2))
						 (0, 0) (300, 331) (2, 2) (is, is) 2000);
	  
	 |] in
  {
	winsize = winsize;
	display = display;
	sprites = sprites;
	font = Sdlttf.open_font Config.font_path Config.font_size;
	pikadat = Sprite.new_tmp_pika 1000;
	pikastats = Stat.load_stats ();
	bgid = 0;
  }

let display d = d.display
let sprites d = d.sprites
let sprite_n d i = d.sprites.(i)
let font d = d.font
let pikadat d = d.pikadat
let pikastats d = d.pikastats
let pikastat_i d i = d.pikastats.(i)
let decay_pikastat d elapsed =
	{d with pikastats = Stat.apply_decay elapsed d.pikastats}
let set_pikadat d pikadat =
	{d with pikadat = pikadat}
let action d action_i =
	match action_i with
	| 4				-> {d with bgid = d.bgid + 1}
	| _				->
		let d = {d with pikastats = Action.apply_action action_i d.pikastats} in
		match action_i with
		| 1			-> set_pikadat d (Sprite.new_tmp_pika ~sid:7 200)
		| 2			-> set_pikadat d (Sprite.new_tmp_pika ~sid:9 500)
		| 3			-> set_pikadat d (Sprite.new_tmp_pika ~sid:8 120)
		| _			-> d
let decay_pikastat d elapsed = {
	d with pikastats = Stat.apply_decay elapsed d.pikastats}
let update_pikadat d elapsed = {
	d with pikadat = Sprite.update_tmppika d.pikadat elapsed}
let bgid d = d.bgid
