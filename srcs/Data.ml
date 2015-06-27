(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Data.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 16:37:26 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/27 18:23:10 by jaguillo         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type data = {
	winsize: (int * int);
	display: Sdlvideo.surface;
	images: Image.t array;
	sprites: Sprite.dat array;
	font: Sdlttf.font
  }

let new_data ((winx, winy) as winsize) =
  let display = Sdlvideo.set_video_mode winx winy [`DOUBLEBUF] in
  {winsize = winsize;
   display = display;
   images =
	 [|
	   (Image.load_texture Config.icon_path 0);
	   (Image.load_texture Config.pikatchu_path 1);
	  |];
   sprites =
	 [|
	   (Sprite.new_sprite 0 1 (0, 91) (58, 58) (15, 15) 1000);
	  |];
	font = Sdlttf.open_font Config.font_path Config.font_size
  }

let display d = d.display
let images d = d.images
let image_n d i = d.images.(i)
let sprites d = d.sprites
let sprite_n d i = d.sprites.(i)
let font d = d.font
