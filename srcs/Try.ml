(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Try.ml                                             :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: jaguillo <jaguillo@student.42.fr>          +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 19:07:16 by jaguillo          #+#    #+#             *)
(*   Updated: 2015/06/27 19:13:06 by jaguillo         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type 'a t = Success of 'a | Failure of exn

exception Fail

let return a = Success (a)

let fail () = Failure (Fail)

let bind a f =
	match a with
	| Success (a')			-> begin try f a' with | e -> Failure (e) end
	| Failure (e) as f		-> f

let recover a f =
	match a with
	| Success (a')			-> a
	| Failure (e)			-> f e


let filter a f =
	match a with
	| Success (a')			-> if f a' then a else Failure (Fail)
	| Failure (e)			-> a

let flatten a =
	match a with
	| Success (a')			-> begin
		match a' with
		| Success (a'')			-> a'
		| Failure (e) as f		-> f
	end
	| Failure (e) as f		-> f
