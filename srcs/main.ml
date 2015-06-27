(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 15:19:59 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/27 16:47:59 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let show img dst =
  let d = Sdlvideo.display_format (Image.sdl_ptr img) in
  Sdlvideo.blit_surface d dst ();
  Sdlvideo.flip dst

let rec wait_key () =
  let e = Sdlevent.wait_event () in
  match e with
	Sdlevent.KEYDOWN _ -> ()
  | _ -> wait_key ()

let rec mainloop ((data, img) as env) =
  show img (Data.get_display data);
  wait_key ()
(* mainloop env *)

let () =
  Printf.printf "Hello world\n%!";
  (* Load SDL *)
  Sdl.init [`EVERYTHING];
  Sdlevent.enable_events Sdlevent.all_events_mask;
  (* Init les datas *)
  (* Main loop *)
  let img = Image.load_texture "./ressources/Icons.jpg" 0 in
  let pika = Image.load_texture "./ressources/Pikachu.png" 0 in
  let data = Data.new_data in
  mainloop (data, pika)
