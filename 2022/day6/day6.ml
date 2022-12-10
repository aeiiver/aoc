(*
  My OCaml experience so far:
  - already had passed a course about it in college
  - installation hell (you guess it right, I do dev on Windows, and I know, this is sinful-)
  - https://v2.ocaml.org/api/ became my friend
*)

let str_to_list str =
  let rec reduce idx acc =
    if idx < 0 then acc
    else reduce (idx - 1) ((str.[idx])::acc)
  in
  reduce (String.length str - 1) []

let sort_asc a b = (Char.code a) - (Char.code b)

let solve buffer_size =
  
  let mark index chars =
    if List.length (List.sort_uniq sort_asc chars) == buffer_size
    then index + buffer_size
    else 0
  in

  let slice message index =
    str_to_list (String.sub message (index - buffer_size + 1) buffer_size)
  in

  let message = input_line (open_in "./day6.prod") in
  let indexes = List.init (String.length message - buffer_size - 1) (fun i -> i + buffer_size - 1) in
  let slices = List.map (fun i -> slice message i) indexes in
  let maybe_markers = List.mapi mark slices in
  let marker = List.find (fun m -> m > 0) maybe_markers in
  Printf.printf "%d\n" marker

let () =
  solve 4; (* 1766 *)
  solve 14; (* 2383 *)
