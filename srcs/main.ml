(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 15:19:59 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/27 17:50:59 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let show data =
  let sprite = Data.sprite_n data 0 in
  let iid = Sprite.iid sprite in
  let img = Data.image_n data iid in
  let d = Sdlvideo.display_format (Image.sdl_ptr img) in
  let dst = Data.display data in
  let rect = Sprite.rect sprite (Sprite.new_tmp sprite) in
  (* Sdlvideo.blit_surface d dst (); *)
  Sdlvideo.blit_surface ~src:d ~src_rect:rect ~dst:dst ();
  Sdlvideo.flip dst

let rec wait_key () =
  let e = Sdlevent.wait_event () in
  match e with
	Sdlevent.KEYDOWN _ -> ()
  | _ -> wait_key ()

let rec mainloop ((data, firstobject) as env) =
  show data;
  (* show (Data.sprite_n data 0) (Data.display data); *)
  wait_key ()
  (* mainloop env *)

let () =
  Printf.printf "Hello world\n%!";
  (* Load SDL *)
  Sdl.init [`EVERYTHING];
  Sdlttf.init ();
  Sdlevent.enable_events Sdlevent.all_events_mask;
  (* Init les datas *)
  (* Main loop *)
  (* let img = Image.load_texture "./ressources/Icons.jpg" 0 in *)
  (* let pika = Image.load_texture "./ressources/Pikachu.png" 0 in *)
  let (winx, winy) as winsize = (500, 500) in
  let data = Data.new_data winsize in
  mainloop (data, new UI.group 0 0 winx winy [
						
					  ])
