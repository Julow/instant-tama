(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Stat.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 17:53:27 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/28 21:02:54 by ngoguey          ###   ########.fr       *)
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

let save_to_file stats =
	try begin
		let chan = open_out Config.save_path in
		let rec write_loop i =
			if i < 0 then
				close_out chan
			else
				output_string chan (string_of_float stats.(i));
				output_char chan '\n';
				write_loop (i - 1)
		in
		write_loop 3
	end with
	| _					-> ()

let load_from_file () =
	let chan = open_in Config.save_path in
	let rec read_loop i stats =
		if i < 0 then begin
			close_in chan; stats
		end else
			let f = float_of_string (input_line chan) in
			if f <= 1. || f > 100. then
				failwith "Bad stat"
			else begin
				stats.(i) <- f;
				read_loop (i - 1) stats
			end
	in
	read_loop 3 ([|100.; 100.; 100.; 100.|])

let load_stats () =
	try load_from_file () with
	| _						-> default_status ()

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
