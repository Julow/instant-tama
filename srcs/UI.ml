(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   UI.ml                                              :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: jaguillo <jaguillo@student.42.fr>          +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 15:07:56 by jaguillo          #+#    #+#             *)
(*   Updated: 2015/06/28 20:04:46 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

class virtual basic_object x y w h =
object
	val _x = x
	val _y = y
	val _width = w
	val _height = h
	val _pressed = false
	val _hover = false

	method _on_event (x:int) (y:int) press hover = {< _pressed = press ; _hover = hover >}
	method on_click (x:int) (y:int) (env:Data.data) = env
	method update (env:Data.data) (elapsed: int) = (env, {< >})
	method virtual draw : int * int -> Data.data -> unit

	method x :int = _x
	method y :int = _y
	method width = _width
	method height = _height
	method pressed = _pressed
	method hover = _hover

	method is_in x y = x >= 0 && y >= 0 && x < _width && y < _height
end

class group x y w h (childs:basic_object list) =
object
	inherit basic_object x y w h

	val _childs = childs

	method _on_event (x:int) (y:int) press hover = {< _pressed = press ; _hover = hover ;
		_childs = List.map (fun c ->
			let x' = x - (c#x) in
			let y' = y - (c#y) in
			if c#is_in x' y' then
				c#_on_event x' y' press hover
			else
				c#_on_event x' y' false false
		) _childs >}

	method on_click x y (env:Data.data) =
		let rec loop = function
			| []								-> env
			| head::tail						->
				let x' = x - head#x in
				let y' = y - head#y in
				if head#is_in x' y' then
					head#on_click x' y' env
				else
					loop tail
		in
		loop _childs

	method draw (x, y) (env:Data.data) =
		List.iter (fun c -> c#draw (x + c#x, y + c#y) env) _childs
	method update (env:Data.data) (elapsed:int) =
		let rec loop env lst acc =
			match lst with
			| []								-> (env, {< _childs = acc >})
			| head::tail						->
				let (env, child) = head#update env elapsed in
				loop env tail (acc @ [child])
		in
		loop env _childs []
end

class text x y =
object
	inherit basic_object x y 0 0
	val _text = ""
	method set_text str font =
		let w, h = Sdlttf.size_text font str in
		{< _text = str ; _width = w ; _height = h >}
	method draw (x, y) (env:Data.data) =
		let surface =
			if _pressed then
				Sdlttf.render_text_solid (Data.font env) _text Sdlvideo.red
			else if _hover then
				Sdlttf.render_text_solid (Data.font env) _text Sdlvideo.green
			else
				Sdlttf.render_text_solid (Data.font env) _text Sdlvideo.blue
		in
		let dst_rect = Sdlvideo.rect x y _width _height in
		Sdlvideo.blit_surface ~src:surface ~dst:(Data.display env) ~dst_rect:dst_rect ()
end

class gameover x y =
object
  inherit text x y as super
	method draw (x, y) (env:Data.data) =
	  if Stat.any_depleted (Data.pikastats env) then
		super#draw (x, y) env

end
  
class sprite x y w h sprite_i =
object
	inherit basic_object x y w h

	val _sprite_i = sprite_i
	val _sprite_state =
	  match sprite_i with
	  | 18			-> Sprite.new_tmp 2
	  | _			-> Sprite.new_tmp 1000

	method draw (x, y) (env:Data.data) =
	  let sprite = Data.sprite_n env _sprite_i in
		let img = Sprite.sdl_ptr sprite in
		let dst = Data.display env in
		let rect = Sprite.rect sprite _sprite_state in
		let dst_rect = Sdlvideo.rect x y 0 0 in
		Sdlvideo.blit_surface ~src:img ~src_rect:rect ~dst:dst ~dst_rect:dst_rect ()

	method update (env:Data.data) (elapsed:int) =
		(env, {< _sprite_state = Sprite.update_tmp _sprite_state elapsed >})

end

class background x y w h sprite_i =
object
  inherit sprite x y w h sprite_i as super

	method draw (x, y) (env:Data.data) =
	  let sprite = Data.sprite_n env _sprite_i in
		let img = Sprite.sdl_ptr sprite in
		let dst = Data.display env in
		let rect = Sprite.rectbg (Data.bgid env) in
		let dst_rect = Sdlvideo.rect x y 0 0 in
		Sdlvideo.blit_surface ~src:img ~src_rect:rect ~dst:dst ~dst_rect:dst_rect ()
									   
end
  
class pika x y w h sprite_i =
object
	inherit sprite x y w h sprite_i

	method draw (x, y) (env:Data.data) =
		let sprite_state = Data.pikadat env in
		let sprite = Data.sprite_n env (Sprite.pikasprite_i sprite_state) in
		let img = Sprite.sdl_ptr sprite in
		let dst = Data.display env in
		let rect = Sprite.rectpika sprite sprite_state in
		let dst_rect = Sdlvideo.rect x y 0 0 in
		Sdlvideo.blit_surface ~src:img ~src_rect:rect ~dst:dst ~dst_rect:dst_rect ()
	method update (env:Data.data) (elapsed:int) =
	  (Data.update_pikadat env elapsed,
	   {< _sprite_state = Sprite.update_tmp _sprite_state elapsed >})
end

class bar x y w h sprite_i stat_i =
object
	inherit sprite x y w h sprite_i

	val _stat_i = stat_i

	method draw (x, y) (env:Data.data) =
		let sprite = Data.sprite_n env _sprite_i in
		let img = Sprite.sdl_ptr sprite in
		let dst = Data.display env in
		let statval = Data.pikastat_i env _stat_i in
		let rect = Sprite.rectbar sprite statval in
		let dst_rect = Sdlvideo.rect x y 0 0 in
		Sdlvideo.blit_surface ~src:img ~src_rect:rect ~dst:dst ~dst_rect:dst_rect ()
end

class button x y w h action_i icon_i =
object
	inherit group x y w h [
		(new sprite Config.iss Config.iss Config.is Config.is icon_i);
		(new sprite 0 0 Config.ibs Config.ibs 3);
	] as super

	val _action_i = action_i
	val _overlay = new sprite 0 ~-1 Config.is Config.is 17
	val _ants = new sprite Config.iss Config.iss Config.ant_size
					Config.ant_size 18

	method draw ((x, y) as pos) env =
	  super#draw pos env;
		if _hover then
			_overlay#draw (x + _overlay#x, y + _overlay#y) env
		else if (Data.pikastat_i env _action_i) <= Config.ants_min then
			_ants#draw (x + _ants#x, y + _ants#y) env
	
	method update env elapsed =
		let env, super = super#update env elapsed in
		if (Data.pikastat_i env _action_i) <= Config.ants_min then
			let env, ants = _ants#update env elapsed in
			(env, {< _ants = ants >})
		else
			(env, super)

	method on_click x y (env:Data.data) =
		let env = super#on_click x y env in
		Data.action env action_i
end
