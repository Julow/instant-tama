(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 15:19:59 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/27 15:57:13 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let show img dst =
  match img with
  | Image.Failure _		-> ()
  | Image.Loaded dat		->
	 let d = Sdlvideo.display_format dat.sdlptr in
	 Sdlvideo.blit_surface d dst ();
	 Sdlvideo.flip dst

let rec wait_key () =
  let e = Sdlevent.wait_event () in
  match e with
	Sdlevent.KEYDOWN _ -> ()
  | _ -> wait_key ()
				   
let rec mainloop ((display, img) as env) =
  show img display;
  wait_key ()
  (* mainloop env *)

let () =
  Printf.printf "Hello world\n%!";
  (* Load SDL *)
  Sdl.init [`EVERYTHING];
  Sdlevent.enable_events Sdlevent.all_events_mask;
  let display = Sdlvideo.set_video_mode 500 500 [`DOUBLEBUF] in
  (* Init les datas *)
  (* Main loop *)
  let img = Image.load_texture "../ressources/Icons.jpg" 0 in
  mainloop (display, img)
