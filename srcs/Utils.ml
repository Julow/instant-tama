(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Utils.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: jaguillo <jaguillo@student.42.fr>          +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 19:50:49 by jaguillo          #+#    #+#             *)
(*   Updated: 2015/06/27 20:00:03 by jaguillo         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let surface_sub src (rect:Sdlvideo.rect) =
	let dst = Sdlvideo.create_RGB_surface_format src [] rect.r_x rect.r_y in
	let dst_rect = Sdlvideo.rect 0 0 rect.r_w rect.r_h in
	Sdlvideo.blit_surface ~src:src ~src_rect:rect ~dst:dst ~dst_rect:dst_rect ();
	dst
