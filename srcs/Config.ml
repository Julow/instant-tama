(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Config.ml                                          :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: jaguillo <jaguillo@student.42.fr>          +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 17:54:32 by jaguillo          #+#    #+#             *)
(*   Updated: 2015/06/28 14:58:49 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

(* 301 331 *)
let w_width = 602
let w_height = 662

let bg_path = "ressources/Backgrounds.png"
let icon_path = "ressources/Icons.png"
let iconborder_path = "ressources/IconBorder.png"
(* let pikatchu_path = "ressources/Pikachu.png" *)
let pikatchu_path = "ressources/Pikachu_transp.png"

let font_path = "ressources/font.ttf"
let font_size = 16


(* ****************************** ICON VALUES ******************************* *)
(* icon_size *)
let is = 90

let icon_size_float = float is

let icon_percent_visible = 0.72
let icon_pixels_visible = icon_size_float *. icon_percent_visible
							 
let border_middle_percent = 0.485
let icon_border_size_float = icon_pixels_visible /. border_middle_percent

(* icon_border_size *)
let ibs = truncate icon_border_size_float

let icon_inset_float = (icon_border_size_float -. icon_size_float) /. 2.
(* icon_inset from border's top left point *)
let iss = truncate icon_inset_float

let icons_margin = ~-10

let icon2_delta = (1 * (icons_margin + ibs))
let icon3_delta = (2 * (icons_margin + ibs))
let icon4_delta = (3 * (icons_margin + ibs))

let icon_group_width = (4 * ibs + 3 * icons_margin)
					
let icon_group_horizontal_pos = (w_width - icon_group_width) / 2
let icon_group_vertical_pos = 662 - icon_group_horizontal_pos / 2 - ibs

(* **************************** PIKACHU VALUES ****************************** *)
let pik_size = 340
let pik_horiz_pos = (w_width - pik_size) / 2
let pik_vert_pos = (w_height - (w_height - icon_group_vertical_pos) - pik_size) / 2
				  
