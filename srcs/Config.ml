(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Config.ml                                          :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: jaguillo <jaguillo@student.42.fr>          +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/27 17:54:32 by jaguillo          #+#    #+#             *)
(*   Updated: 2015/06/28 20:28:18 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

(* 301 331 *)
let w_width = 602
let w_height = 662

let save_path = "save.itama"

let bg_path = "ressources/Backgrounds.png"
let icon_path = "ressources/Icons.png"
let iconborder_path = "ressources/IconBorder.png"
(* let pikatchu_path = "ressources/Pikachu.png" *)
let pikatchu_path = "ressources/Pikachu_transp.png"
let hpbar_path = "ressources/Healh_bar.png"
let manabar_path = "ressources/Energy_bar.png"
let hygbar_path = "ressources/Hygiene_bar.png"
let hapbar_path = "ressources/Hapyness_bar.png"
let fill1_path = "ressources/Generic1.png"
let fill2_path = "ressources/Generic2.png"
let fill3_path = "ressources/Generic3.png"
let iconalert = "ressources/IconAlert.png"
let iconalertants = "ressources/IconAlertAnts.png"
				   
let font_path = "ressources/font.ttf"
let font_size = 83


(* ****************************** ICON VALUES ******************************* *)
(* icon_size *)
let is = 75

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
let icon5_delta = (4 * (icons_margin + ibs))

let icon_group_width = (5 * ibs + 4 * icons_margin)
					
let icon_group_horizontal_pos = (w_width - icon_group_width) / 2
let icon_group_vertical_pos = 662 - icon_group_horizontal_pos / 2 - ibs

let hover_sizef = 1.47 *. icon_size_float
let hover_offsetf = (hover_sizef -. icon_size_float) /. 2.
let hover_offset = truncate hover_offsetf
let hover_size = truncate hover_sizef

let ant_size = is


(* ****************************** BAR VALUES ******************************** *)
let bar_width = 250
let bar_ratio = 0.2
let bar_height = truncate (float bar_width *. bar_ratio)
let bar_group_vert_margin = 5
let bar_group_horiz_margin = 30


(* **************************** PIKACHU VALUES ****************************** *)
let pik_size = 340
let pik_horiz_pos = (w_width - pik_size) / 2

let bot_group_height = (w_height - icon_group_vertical_pos)
let top_group_height = (bar_group_vert_margin * 2 + bar_height * 2)
let pik_vert_pos = top_group_height +
					 (w_height - top_group_height - bot_group_height
					  - pik_size) / 2
let ants_min = 35.
