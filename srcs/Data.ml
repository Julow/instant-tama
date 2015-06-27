(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Data.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 16:37:26 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/27 17:46:55 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type data = {
	winsize: (int * int);
	display: Sdlvideo.surface;
	images: Image.t array;
	sprites: Sprite.dat array
  }

let new_data ((winx, winy) as winsize) =
  let display = Sdlvideo.set_video_mode winx winy [`DOUBLEBUF] in
  {winsize = winsize;
   display = display;
   images =
	 [|
	   (Image.load_texture "./ressources/Icons.jpg" 0);
	   (Image.load_texture "./ressources/Pikachu.png" 1);
	  |];
   sprites =
	 [|
	   (Sprite.new_sprite 0 1 (0, 91) (58, 58) (15, 15) 1000);
	  |];
  }

let display d = d.display
let images d = d.images
let image_n d i = d.images.(i)
let sprites d = d.sprites
let sprite_n d i = d.sprites.(i)
