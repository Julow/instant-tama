(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   UI.ml                                              :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: jaguillo <jaguillo@student.42.fr>          +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 15:07:56 by jaguillo          #+#    #+#             *)
(*   Updated: 2015/06/27 15:22:29 by jaguillo         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

class virtual basic_object x y w h = object
	val _x = x
	val _y = y
	val _width = w
	val _height = h
	method virtual on_click :basic_object
	method virtual draw :unit
	method virtual update :basic_object
	method x = _x
	method y = _y
	method width = _width
	method height = _height
	method is_in x y =
		let right = _x + _width in
		let bottom = _y + _height in
		x >= _x && y >= _y && x < right && y < bottom
end
