(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Data.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 16:37:26 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/28 12:57:36 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type data = {
	winsize: (int * int);
	display: Sdlvideo.surface;
	sprites: Sprite.dat array;
	font: Sdlttf.font
  }

let new_data ((winx, winy) as winsize) =
  let display = Sdlvideo.set_video_mode winx winy [`DOUBLEBUF] in
  let images = [|
	  (Image.load_texture Config.icon_path 0);
	  (Image.load_texture Config.pikatchu_path 1);
	  (Image.load_texture Config.bg_path 2);
	  (Image.load_texture Config.iconborder_path 3);
	 |] in
  let sprites = [|
	  (Sprite.new_sprite 0 1 (Image.sdl_ptr images.(1))
						 (0, 91) (58, 58) (15, 15) (200, 200) 1000);
	  (Sprite.new_sprite 1 2 (Image.sdl_ptr images.(2))
						 (0, 0) (301, 331) (4, 2)
						 (Config.w_width, Config.w_height) 1000);
	  (Sprite.new_sprite 2 0 (Image.sdl_ptr images.(0))
						 (0, 0) (64, 64) (4, 1) (64, 64) 1000);
	  (Sprite.new_sprite 3 3 (Image.sdl_ptr images.(3))
						 (0, 0) (72, 72) (1, 1) (92, 92) 1000);
	  (Sprite.new_sprite 4 0 (Image.sdl_ptr images.(0))
						 (64, 0) (64, 64) (4, 1) (64, 64) 1000);
	  (Sprite.new_sprite 5 0 (Image.sdl_ptr images.(0))
						 (128, 0) (64, 64) (4, 1) (64, 64) 1000);
	  (Sprite.new_sprite 6 0 (Image.sdl_ptr images.(0))
						 (192, 0) (64, 64) (4, 1) (64, 64) 1000);
	 |] in
  {
	winsize = winsize;
	display = display;
	sprites = sprites;
	font = Sdlttf.open_font Config.font_path Config.font_size
  }

let display d = d.display
let sprites d = d.sprites
let sprite_n d i = d.sprites.(i)
let font d = d.font
