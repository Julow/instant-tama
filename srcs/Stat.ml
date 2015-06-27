(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Stat.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 17:53:27 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/27 18:54:50 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type t = float array

let details =
  [|
	(* (INDEX, NAME, LOSSPERSEC) *)
	(0, "Health", 1.);
	(1, "Energy", 0.);
	(2, "Hygiene", 0.);
	(3, "Happyness", 0.);
  |]

let default_status =
  [|100.; 100.; 100.; 100.|]

let n = Array.length details

(** elapsed: elapsed miliseconds (sdl time)
 ** sv: Stats values *)
let apply_decay elapsed sv: t =
  Array.mapi (fun i v -> let (_, _, d) = details.(i) in v -. d) sv