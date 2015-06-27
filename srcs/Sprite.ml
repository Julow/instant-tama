(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Sprite.ml                                          :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 15:46:20 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/27 15:55:51 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type dat = {sid : int;
			tid : int;
			x0 : int; y0 : int;
			x : int; y : int;
			n : int; ncol : int;
			def_dt : int}

type tmpdat = {tslu : int;
			   dt : int;
			   phase : int}
			

let get_rect d td =
  let line = d.ncol / td.phase in
  let col = d.ncol mod td.phase in
  let x = d.x0 + d.x * col in
  let y = d.y0 + d.y * line in
  (x, x + d.x, y, y + d.y)

let update_tmp td elapsed =
  if elapsed > td.dt then
	{td with tslu = 0; phase = td.phase + 1}
  else
	td

let new_tmp d =
  {tslu = 0; dt = d.def_dt; phase = 0}
