(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Image.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 15:05:37 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/27 17:11:02 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type t = {tid: int; filename: string; w: int; h: int;
		  sdlptr: Sdlvideo.surface}
		   
let load_texture filename i =
  let img = Sdlloader.load_image filename in
  let infos = Sdlvideo.surface_info img in
  {tid = i
  ;filename = filename
  ;w = infos.Sdlvideo.w
  ;h = infos.Sdlvideo.h
  ;sdlptr = img}

let sdl_ptr dat = dat.sdlptr
