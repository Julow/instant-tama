(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Sprite.ml                                          :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 15:46:20 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/28 19:03:08 by ngoguey          ###   ########.fr       *)
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

let new_tmp dt : tmpdat =
  {tslu = 0; dt = dt; phase = 0}

let new_tmp_pika ?(sid = 0) dt : tmpdatpika =
  {tslu = 0; dt = dt; phase = 0; spriteid = sid}

let rect (d : dat) (td: tmpdat) =
  let phase = td.phase mod d.n in	
  let line = phase / d.ncol in
  let col = phase mod d.ncol in
  let x = d.x0 + d.iw * col in
  let y = d.y0 + d.ih * line in
  if d.n = 25 then begin
	  Printf.printf "Rendering %2d\n%!" phase
	end;
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

let update_tmp (td: tmpdat) elapsed =
  if td.tslu > td.dt then
	{td with tslu = td.tslu - td.dt; phase = td.phase + 1}
  else
	{td with tslu = td.tslu + elapsed}

let update_tmppika (td: tmpdatpika) elapsed =
  match td.spriteid with
  | 7 when td.phase >= 10	-> new_tmp_pika 1000
  | 8 when td.phase >= 8	-> new_tmp_pika 1000
  | 9 when td.phase >= 7	-> new_tmp_pika 1000
  | _ when td.tslu > td.dt	-> {td with tslu = 0; phase = td.phase + 1}
  | _						-> {td with tslu = td.tslu + elapsed}

