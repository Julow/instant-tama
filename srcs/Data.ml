(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Data.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 16:37:26 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/28 12:24:24 by ngoguey          ###   ########.fr       *)
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
	 |] in
  let sprites = [|
	  (Sprite.new_sprite 0 1 (Image.sdl_ptr images.(1))
						 (0, 91) (58, 58) (15, 15) (200, 200) 1000);
	  (Sprite.new_sprite 1 2 (Image.sdl_ptr images.(2))
						 (0, 0) (301, 331) (1, 1) (400, 460) 1000_000);
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
