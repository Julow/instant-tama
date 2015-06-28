(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Sprite.ml                                          :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 15:46:20 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/28 17:24:44 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type dat = {sid : int;
			(* iid : int; *)
			x0 : int; y0 : int;
			iw : int; ih : int;
			n : int; ncol : int;
			def_dt : int;
			sdl_ptr : Sdlvideo.surface
		   }

type tmpdat = {tslu : int;
			   dt : int;
			   phase : int}

type tmpdatpika = {tslu : int;
				   dt : int;
				   phase : int;
				   spriteid : int;}

let update_tmp (td: tmpdat) elapsed =
  if elapsed > td.dt then
	{td with tslu = 0; phase = td.phase + 1}
  else
	{td with tslu = td.tslu + elapsed}

let update_tmppika (td: tmpdatpika) elapsed =
  (* Printf.printf "%d > %d = %B\n%!" elapsed td.dt (elapsed > td.dt); *)
  if td.tslu > td.dt then
	{td with tslu = 0; phase = td.phase + 1}
  else
	{td with tslu = td.tslu + elapsed}

(** sid: sprite id (current)
 ** iid: image id
 ** x0, y0: Point0 coords (in image)
 ** iw, ih: Single sprite dimentions (in image)
 ** n: num sprites
 ** ncol: num columns (in image) (sprites per row)
 ** reqw, reqh: required dimentions for the final image
 ** def_ft: default delta time between two spites
 ** oldzw, oldzh: old zone dimentions
 *)
let new_sprite sid iid img (x0, y0) (iw, ih) (n, ncol) (reqw, reqh) def_dt =  
  let img = Sdlvideo.display_format img ~alpha:true in
  let (zoomw, zoomh) = (float reqw /. float iw, float reqh /. float ih) in
  let newzone = Sdlgfx.zoomSurface img zoomw zoomh false in
  {
	sid = sid;
	x0 = truncate (float x0 *. zoomw); y0 = truncate (float y0 *. zoomh);
	iw = reqw; ih = reqh;
	n = n; ncol = ncol;
	def_dt = def_dt;
	sdl_ptr = newzone
  }

let new_tmp () : tmpdat =
  {tslu = 0; dt = 1000; phase = 0}
	
let new_tmp_pika () : tmpdatpika =
  {tslu = 0; dt = 200; phase = 0; spriteid = 7}
	
let rect (d : dat) (td: tmpdat) =
  let phase = td.phase mod d.n in
  let line = phase / d.ncol in
  let col = phase mod d.ncol in
  let x = d.x0 + d.iw * col in
  let y = d.y0 + d.ih * line in
  Sdlvideo.rect x y d.iw d.ih

let rectbar (d : dat) status =
  let right = truncate ((status /. 100.) *. 186.) + 35 in
  Sdlvideo.rect 0 0 right d.ih

let rectpika (d : dat) (td: tmpdatpika) =
  let phase = td.phase mod d.n in
  let line = phase / d.ncol in
  let col = phase mod d.ncol in
  let x = d.x0 + d.iw * col in
  let y = d.y0 + d.ih * line in
  Sdlvideo.rect x y d.iw d.ih

let sdl_ptr dat = dat.sdl_ptr

let pikasprite_i (d: tmpdatpika) = d.spriteid
