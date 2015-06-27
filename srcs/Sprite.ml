(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Sprite.ml                                          :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 15:46:20 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/27 17:13:27 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type dat = {sid : int;
			iid : int;
			x0 : int; y0 : int;
			x : int; y : int;
			n : int; ncol : int;
			def_dt : int}

type tmpdat = {tslu : int;
			   dt : int;
			   phase : int}


let update_tmp td elapsed =
  if elapsed > td.dt then
	{td with tslu = 0; phase = td.phase + 1}
  else
	td

let new_sprite sid iid (x0, y0) (x, y) (n, ncol) def_dt =
  {sid = sid; iid = iid; x0 = x0; y0 = y0; x = x; y = y; n = n; ncol = ncol;
   def_dt = def_dt}

let new_tmp d =
  {tslu = 0; dt = d.def_dt; phase = 0}

let rect d td =
  let line = d.ncol / td.phase in
  let col = d.ncol mod td.phase in
  let x = d.x0 + d.x * col in
  let y = d.y0 + d.y * line in
  Sdlvideo.rect x y d.x d.y
(* (x, x + d.x, y, y + d.y) *)

let iid d = d.iid
