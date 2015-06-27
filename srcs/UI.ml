(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   UI.ml                                              :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: jaguillo <jaguillo@student.42.fr>          +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 15:07:56 by jaguillo          #+#    #+#             *)
(*   Updated: 2015/06/27 17:40:41 by jaguillo         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

class virtual basic_object x y w h =
object
	val _x = x
	val _y = y
	val _width = w
	val _height = h

	method on_click (x:int) (y:int) (env:Data.data) = env
	method update (env:Data.data) = {< >}
	method virtual draw :Data.data -> unit

	method x = _x
	method y = _y
	method width = _width
	method height = _height

	method is_in x y =
		let right = _x + _width in
		let bottom = _y + _height in
		x >= _x && y >= _y && x < right && y < bottom
end

class group x y w h childs =
object
	inherit basic_object x y w h

	val _childs = childs

	method on_click x y (env:Data.data) =
		let rec loop = function
			| []								-> env
			| head::tail when head#is_in x y	-> head#on_click x y env
			| head::tail						-> loop tail
		in
		loop _childs
	method draw (env:Data.data) = List.iter (fun c -> c#draw env) _childs
	method update (env:Data.data) = {< _childs = List.map (fun c ->
			c#update env
		) _childs >}
end

class text x y =
object
	inherit basic_object x y 0 0
	val _text = ""
	method set_text str font =
		let w, h = Sdlttf.size_text font str in
		{< _text = str ; _width = w ; _height = h >}
	method draw (env:Data.data) =
		let surface = Sdlttf.render_text_solid (Data.font env) _text Sdlvideo.black in
		let dst_rect = Sdlvideo.rect _x _y _width _height in
		Sdlvideo.blit_surface ~src:surface ~dst:(Data.display env) ~dst_rect:dst_rect ()
end
