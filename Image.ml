(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Image.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 15:05:37 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/27 15:13:22 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type dat = {tid: int; filename: string; w: int; h: int; sdlptr: Sdlvideo.surface}

type t = Loaded of dat | Failure of string

let load_texture filename i =
  let img = Sdlloader.load_image filename in
  if true then
	begin
	  let infos = Sdlvideo.surface_info img in
	  Loaded {tid = i
			 ;filename = filename
			 ;w = infos.Sdlvideo.w
			 ;h = infos.Sdlvideo.h
			 ;sdlptr = img}
	end
  else
	Failure ("Could not load image: " ^ filename)
