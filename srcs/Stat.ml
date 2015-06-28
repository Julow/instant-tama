(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Stat.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 17:53:27 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/28 19:24:51 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type t = float array

let details = [|
	(* (INDEX, NAME, LOSSPERSEC) *)
	(0, "Health", 1.);
	(1, "Energy", 0.);
	(2, "Hygiene", 0.);
	(3, "Happyness", 0.);
|]

let default_status () = [|100.; 100.; 100.; 100.|]

let n = Array.length details

(** elapsed: elapsed miliseconds (sdl time)
 ** sv: Stats values *)
let apply_decay elapsed (sv: t) : t =
	let ef = float elapsed in
	Array.mapi (fun i v ->
			let (_, _, d) = details.(i) in
			max (min (v -. (d *. ef /. 1000.)) 100.) 0.
		) sv

let any_depleted (sv: t) =
  Array.fold_left (fun prev v -> if prev || v < 1. then true else false)
				  false sv
